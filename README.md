# FTSOv2 Fee/Reward Distributor

A set of smart contracts to automate the distribution of the fees generated by the FTSOv2 protocol. The primary use case is to simplify the work of the FTSOv2 voters, that every epoch need to claim the fee, fund the voter addresses with the gas needed for submit/submitSignatures/signingPolicy/fast-updates transactions, and wrap the remaining for compounding rewards, but it can be used by anyone that has similar needs.

A voter can instantiate a new smart contract where to claim the rewards to, by calling the `create` function of the `FtsoV2RewardDistributorFactory` contract, and by parsing the generated `Created` event to get the new instance address. It's not necessary to use the voter's private key to sign the transaction.

The parameters to be passed are:

- `voters`: an array of addresses to maintain a minimum balance, i.e. FTSOv2 voters [submitAddress, submitSignaturesAddress, signingPolicyAddress, fastUpdateAddresses]
- `reserveBalances`: an array of the desired balances (in wei) of the voter's, it'll be refilled to match the value, if necessary. It has to have the same length as the voters array
- `recipients`: an array of addresses, where the voter's fee will be sent to, in different percentages
- `bips`: an array of basis points, corresponding to the different shares for each recipient; it has to have the same length as the recipient array and the sum must be 10000 (100.00%)
- `wrap`: an array of booleans, to specify if the corresponding fee share needs to be wrapped (for auto-delegation) or not
- `editable`: a boolean to allow successive modification of the reserveBalance, recipients and bips
- `description`: an optional string to identify the contract, useful for a management UI

The newly generated address has to be used as the `recipient` of the `RewardManager.claim` function. During the fee distribution the smart contract emits specific events for each performed transfer, that can be used for accounting purposes.

## Deployments

`FtsoV2RewardDistributorFactory`
| Chain | Address |
|----------| -------------------------------------------- |
| Coston | [0x397e0558215fB67b2A250e1973b50461E5D4D03a](https://coston-explorer.flare.network/address/0x397e0558215fB67b2A250e1973b50461E5D4D03a) |
| Songbird | [0x397e0558215fB67b2A250e1973b50461E5D4D03a](https://songbird-explorer.flare.network/address/0x397e0558215fB67b2A250e1973b50461E5D4D03a) |
| Flare | [0x397e0558215fB67b2A250e1973b50461E5D4D03a](https://flare-explorer.flare.network/address/0x171eB1f854A7e542D88d6f6fb8827C83236C1937) |

<!-- | Coston2  | [0x171eB1f854A7e542D88d6f6fb8827C83236C1937](https://coston2-explorer.flare.network/address/0x171eB1f854A7e542D88d6f6fb8827C83236C1937) | -->
