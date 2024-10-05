intro_contract
intro_contract
sncast account create --url https://free-rpc.nethermind.io/sepolia-juno/ --name intro_contract  
command: account create
add_profile: --add-profile flag was not set. No profile added to snfoundry.toml
address: 0x14e27cf3cadb8d9354cb6a7e57ddfb04dc07bd422aa77234611ac8bea989f20
max_fee: 6909344028795
message: Account successfully created. Prefund generated address with at least <max_fee> STRK tokens or an equivalent amount of ETH tokens. It is good to send more in the case of higher demand.

To see account creation details, visit:
account: https://sepolia.starkscan.co/contract/0x14e27cf3cadb8d9354cb6a7e57ddfb04dc07bd422aa77234611ac8bea989f20
0x014e27cf3cadb8d9354cb6a7e57ddfb04dc07bd422aa77234611ac8bea989f20

sncast --profile intro_contract account deploy --name intro_contract --fee-token eth                                         
command: account deploy
transaction_hash: 0x32e93bcd074e49bb9b4b728c89f1655dd4db57f741f773c9b30425df5fca699

To see invocation details, visit:
transaction: https://sepolia.starkscan.co/tx/0x32e93bcd074e49bb9b4b728c89f1655dd4db57f741f773c9b30425df5fca699

sncast --account intro_contract declare --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --contract-name CounterV2 
Compiling cairo_bootcamp_3 v0.1.0 (/Users/user/Documents/dev/web3/cairo-bootcamp-3/Scarb.toml)
    Finished release target(s) in 6 seconds
command: declare
class_hash: 0x62348eca978957b7d06841b55cde76b2b01cf99483c6d2c947cb3bbcaff5d86
transaction_hash: 0x1cf5c43dd7122e23f5247f408d4152659b036250697bc3f89eed8f5de813fc6

To see declaration details, visit:
class: https://sepolia.starkscan.co/class/0x62348eca978957b7d06841b55cde76b2b01cf99483c6d2c947cb3bbcaff5d86
transaction: https://sepolia.starkscan.co/tx/0x1cf5c43dd7122e23f5247f408d4152659b036250697bc3f89eed8f5de813fc6

 sncast --account intro_contract  deploy --url https://free-rpc.nethermind.io/sepolia-juno  --fee-token eth --class-hash 0x62348eca978957b7d06841b55cde76b2b01cf99483c6d2c947cb3bbcaff5d86
command: deploy
contract_address: 0x4e7e5c55a8f11831bc6d9c570d00812ddd80c3f7476f5cde64e8a0f395a931f
transaction_hash: 0x3bdee78c8923a765011a4eea27c102978fe1a9cf8c5500024bb991ffe21d3ad

To see deployment details, visit:
contract: https://sepolia.starkscan.co/contract/0x4e7e5c55a8f11831bc6d9c570d00812ddd80c3f7476f5cde64e8a0f395a931f
transaction: https://sepolia.starkscan.co/tx/0x3bdee78c8923a765011a4eea27c102978fe1a9cf8c5500024bb991ffe21d3ad

