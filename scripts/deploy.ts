const { deployContract } = require("./utils");

async function main() {
  await deployContract("FtsoV2RewardDistributorFactory", []);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
