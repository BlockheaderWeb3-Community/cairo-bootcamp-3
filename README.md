# Introduction to Starknet Components

## What are Starknet Components

Developing contracts that share common logic and storage often leads to repetition and potential bugs, as this functionality usually has to be re-implemented in each contract. However, components offer a way to streamline this process by allowing developers to integrate only the additional features they need, keeping the core contract logic separate from the rest.

Components act like modular units, encapsulating reusable logic, storage, and events, which can be included in multiple contracts. This eliminates the need to duplicate code, making it easier to expand a contract's capabilities.

Much like building with Lego bricks, components let you enhance a contract's functionality by plugging in pre-built modules, which could be as simple as an ownership feature or a full-fledged ERC20 token.

## What's in a Component
A component is very similar to a contract. It can contain:

- Storage variables
- Events
- External and internal functions

> `NB`
> Unlike contracts, components are not deployed independently. Instead, their logic becomes part of the contract's ABI they are embedded in.

## Creating a Component
To create a component, first define it in its own module decorating it with `#[starknet::component]` attribute.
```Rust
#[starknet::component]
pub mod ownable_component {
   // component logic
}
```

### Defining Component's interface
The next step involves defining the component interface, which contains the function signatures that allow external access to the component’s logic. This is done by defining a trait and decorating it with the `#[starknet::interface]` attribute, similar to how contract interfaces are defined. This trait serves as the component's interface and allow external access to its functions via the dispatcher pattern.
```Rust
#[starknet::interface]
trait IOwnable<TContractState> {
   fn owner(self: @TContractState) -> ContractAddress;
   fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
   fn renounce_ownership(ref self: TContractState);
}
```

### Storage and Events
Storage variables are stored in the storage struct, and event variants are defined and added to the component's events enum similar to how they are defined in contracts.
```Rust
#[storage]
pub struct Storage {
   owner: ContractAddress
}

#[event]
#[derive(Drop, starknet::Event)]
pub enum Event {
   OwnershipTransferred: OwnershipTransferred
}

#[derive(Drop, starknet::Event)]
struct OwnershipTransferred {
   previous_owner: ContractAddress,
   new_owner: ContractAddress,
}
```

### The Implementation block
The component's external logic is implemented within an `impl` block that is decorated with the `#[embeddable_as(name)]` attribute. Typically, this impl block corresponds to the trait that defines the component’s interface. By embedding this block, the logic becomes part of the contract that integrates the component. Functions within these impl blocks take specific arguments based on the type of function. For state-modifying functions, the argument is `ref self: ComponentState<TContractState>`, while for view functions, it is `self: @ComponentState<TContractState>`. This makes the implementation generic over `TContractState`, allowing the component to be reused across different contracts.
```Rust
#[embeddable_as(Ownable)]
impl OwnableImpl<TContractState, +HasComponent<TContractState>> of super::IOwnable<ComponentState<TContractState>> {
   // component trait implementation
}
```

> `NB:`
> `name` in the `#[embeddable_as(name)]` attribute is the name that we’ll be using in the contract to refer to the component. It is different than the name of your `impl`.

Internal functions can be defined by omitting the `#[embeddable_as(name)]` attribute above the `impl` block. These internal functions are not exposed externally and won't be part of the contract's ABI. However, they can still be used within the contract that embeds the component, providing functionality that is internal to the contract but inaccessible from outside.
```Rust
#[generate_trait]
pub impl InternalImpl<TContractState, +HasComponent<TContractState>> of InternalTrait<TContractState> {
   // component internal implementation
}
```

### Putting it all together
```Rust
#[starknet::component]
pub mod ownable_component {
   use core::starknet::{ContractAddress, get_caller_address};
   use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
   use super::Errors;
   use core::num::traits::Zero;

   #[storage]
   pub struct Storage {
      owner: ContractAddress
   }

   #[event]
   #[derive(Drop, starknet::Event)]
   pub enum Event {
      OwnershipTransferred: OwnershipTransferred
   }

   #[derive(Drop, starknet::Event)]
   struct OwnershipTransferred {
      previous_owner: ContractAddress,
      new_owner: ContractAddress,
   }

   #[embeddable_as(Ownable)]
   impl OwnableImpl<
      TContractState, +HasComponent<TContractState>
   > of super::IOwnable<ComponentState<TContractState>> {
      fn owner(self: @ComponentState<TContractState>) -> ContractAddress {
         self.owner.read()
      }

      fn transfer_ownership(
         ref self: ComponentState<TContractState>, new_owner: ContractAddress
      ) {
         assert(!new_owner.is_zero(), Errors::ZERO_ADDRESS_OWNER);
         self.assert_only_owner();
         self._transfer_ownership(new_owner);
      }

      fn renounce_ownership(ref self: ComponentState<TContractState>) {
         self.assert_only_owner();
         self._transfer_ownership(Zero::zero());
      }
   }

   #[generate_trait]
   pub impl InternalImpl<
      TContractState, +HasComponent<TContractState>
   > of InternalTrait<TContractState> {
      fn initializer(ref self: ComponentState<TContractState>, owner: ContractAddress) {
         self._transfer_ownership(owner);
      }

      fn assert_only_owner(self: @ComponentState<TContractState>) {
         let owner: ContractAddress = self.owner.read();
         let caller: ContractAddress = get_caller_address();
         assert(!caller.is_zero(), Errors::ZERO_ADDRESS_CALLER);
         assert(caller == owner, Errors::NOT_OWNER);
      }

      fn _transfer_ownership(
         ref self: ComponentState<TContractState>, new_owner: ContractAddress
      ) {
         let previous_owner: ContractAddress = self.owner.read();
         self.owner.write(new_owner);
         self
               .emit(
                  OwnershipTransferred { previous_owner: previous_owner, new_owner: new_owner }
               );
      }
   }
}
```