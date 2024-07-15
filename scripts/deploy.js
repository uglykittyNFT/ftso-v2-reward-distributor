const { deployContract } = require('./utils')

async function main() {
  await deployContract('RewardV2DistributorFactory', [])
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
