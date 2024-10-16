<!--ASSIGNMENT CREATED ON 11/10/2024-->

# ASSIGNMENT 4

## Introduction to Dispatchers
Dispatcher provides an easy way to call other contracts. We have 2 contracts:
1. `Ownable` 
2. `Counter` 

Both contracts have their respective `IContractDispatcher` and `IContractDispatcherTrait` traits that can be used within the caller `Aggregator` contract to target the methods we intend to call

- Create a `KillSwitch` contract
- Add logic to `Aggregator` contract to ensure that the `is_on` variable of the `KillSwitch` contract is set to true before proceeding to adjust the `set_counter_count` method of `Counter` contract
- Write tests to validate that all the methods of your `Aggregator` contract is functional
- Create a PR with your modifications to the main branch of [cairo-bootcamp-3 repo]( https://github.com/BlockheaderWeb3-Community/cairo-bootcamp-3)

