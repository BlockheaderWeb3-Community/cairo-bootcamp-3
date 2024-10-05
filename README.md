## Introduction to Starknet Contracts

1. Install starknet-foundry by running this command:
   `curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh`

2. Restart your terminal
   run `snfoundryup`

3. Use this free RPC provider: https://free-rpc.nethermind.io/sepolia-juno/

4. Create an account contract by running this command on your terminal:
   `sncast account create --url https://free-rpc.nethermind.io/sepolia-juno --name cohort_dev`

5. Deploy the account contract:
   `sncast account deploy --url https://free-rpc.nethermind.io/sepolia-juno --name cohort_dev --fee-token eth`

> `NB`
> Running the above command should trigger an error:
> `error: Account balance is smaller than the transaction's max_fee`.
> That why your account must be funded; to fund your account, visit - https://starknet-faucet.vercel.app/ and paste the account address that was generated on step 4 to request for testnet token.

6. Compile your contract by running:
   `scarb build`


> If you get an error like `scarb: command not found`, then it means you don't have scarb installed. To install scarb, run this command in your terminal `curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh`. You can checkout the full guide [here](https://docs.swmansion.com/scarb/download.html) 

7. Declare your contract:
   `sncast --account cohort_dev declare --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --contract-name Counter`
   > Example of a contract name is `Counter`



8. Deploy your contract:
   `sncast --account cohort_dev deploy --url https://free-rpc.nethermind.io/sepolia-juno --fee-token eth --class-hash 0x70eef4488bd1858900685210e5afb64d827e6e2bebfd85b01ff8b46d4584471`



🥳🥳🥳 You have successfully deployed your first contract

Alternatively, you can create a `snfoundry.toml` with the following config:

```
[sncast.deploy_dev]
account = "deploy_dev"
accounts-file = "~/.starknet_accounts/starknet_open_zeppelin_accounts.json"
url = "https://free-rpc.nethermind.io/sepolia-juno/"
```

##### Super-charge your `sncast` by adding a profile
This approach simplifies interactions using `sncast` as you can simply run commands completely eliminating the need to to add `--url` and `--name` flags whenever you want to run each sncast command:
`sncast --profile <name_of_profile_on_snfoundry.toml> declare --contract-name <name_of_contract_to_be_deployed>`
Eg: `sncast -u https://free-rpc.nethermind.io/sepolia-juno/ account create -n cohort_dev --add-profile cohort_dev`. This command automatically creates a profile for you in the root of your project directory. Meaning you will find an auto-created file named `snfoundry.toml` file  with the following configurations:
```
[sncast.cohort_dev] 
account = "cohort_dev" 
accounts-file  = "~/.starknet_accounts/starknet_open_zeppelin_accounts.json" 
url = "https://free-rpc.nethermind.io/sepolia-juno/"
```

While deploying, make sure you check the constructor argument of the contract you are trying to deploy. All arguments must be passed in appropriately; for such case, use this command:
`sncast  --profile <name_of_profile_on_snfoundry.toml>  --class-hash <your_class_hash>  --constructor-calldata <your_constructor_args>`

---



---

##### Interacting with Deployed Contracts

- Invoke: to execute the logic of a state-changing (writes) function within your deployed contracts from the terminal, run
  `sncast --url https://free-rpc.nethermind.io/sepolia-juno --account cohort_dev invoke --contract-address <your_contract_address> --function "<your_function_name>" --calldata 10`
  If you have configured your `snfoundry.toml` file, run:
  `sncast --profile <your_profile> invoke --contract-address <your_contract_address> --function "<your_function_name>" --calldata <fn_args>`

- Call: to execute the logic of a non-state-changing (reads) function within your deployed contracts from the terminal, run:
  `sncast --url https://free-rpc.nethermind.io/sepolia-juno --account cohort_dev call --contract-address <your_contract_address> --function "<your_function_name>"`

NB:
In the event the function to be called accepts some args, append the call `--calldata` flag to the above invoke and call commands with the appropriate args.

To compile your contract, run `scarb build`
