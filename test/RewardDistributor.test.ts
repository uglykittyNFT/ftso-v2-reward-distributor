import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre, { artifacts } from "hardhat";
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
// import { FakeContract, smock } from "@defi-wonderland/smock"; // does not work with ether V6
import {
  IFlareContractRegistry,
  IFlareContractRegistry__factory,
  IWNat__factory,
  FtsoV2RewardDistributor,
} from "../typechain-types";

describe("FtsoV2RewardDistributor", function () {
  let ftsoV2RewardDistributor: FtsoV2RewardDistributor;
  let owner: HardhatEthersSigner;
  let submit: HardhatEthersSigner;
  let submitSignatures: HardhatEthersSigner;
  let signingPolicy: HardhatEthersSigner;
  let recipient1: HardhatEthersSigner;
  let recipient2: HardhatEthersSigner;

  async function deployRewardDistributorFixture() {
    // Contracts are deployed using the first signer/account by default
    const [
      owner,
      submit,
      submitSignatures,
      signingPolicy,
      recipient1,
      recipient2,
    ] = await hre.ethers.getSigners();

    const voters = [submit, submitSignatures, signingPolicy];
    const reserveBalance = hre.ethers.parseEther("120.0");
    const reserveBalances = [reserveBalance, reserveBalance, reserveBalance];
    const recipients = [recipient1, recipient2];
    const bips = [7500n, 2500n];
    const wrap: boolean[] = [false, false];

    const rewardDistributor = await hre.ethers.deployContract(
      "FtsoV2RewardDistributor",
      [
        voters.map((x) => x.address),
        reserveBalances,
        recipients.map((x) => x.address),
        bips,
        wrap,
        owner,
      ],
    );

    return {
      rewardDistributor,
      owner,
      submit,
      submitSignatures,
      signingPolicy,
      recipient1,
      recipient2,
    };
  }

  describe("RewardDistributor", function () {
    describe("Claim distribution", function () {
      before(async function () {
        const res = await loadFixture(deployRewardDistributorFixture);

        ftsoV2RewardDistributor = res.rewardDistributor;
        owner = res.owner;
        submit = res.submit;
        submitSignatures = res.submitSignatures;
        signingPolicy = res.signingPolicy;
        recipient1 = res.recipient1;
        recipient2 = res.recipient2;

        const rewardDistributorAdddress = await ftsoV2RewardDistributor.getAddress();
        const claimAmount = hre.ethers.parseEther("1000.0");

        await owner.sendTransaction({
          to: rewardDistributorAdddress,
          value: claimAmount,
        });
      });

      it("Should re-fill the submit account", async function () {
        const reserveBalance = hre.ethers.parseEther("120.0");
        await expect(await getBalance(submit.address)).to.be.eq(reserveBalance);
      });

      it("Should re-fill the submitSignatures account", async function () {
        const reserveBalance = hre.ethers.parseEther("120.0");
        await expect(await getBalance(submitSignatures.address)).to.be.eq(
          reserveBalance,
        );
      });

      it("Should re-fill the signingPolicy account", async function () {
        const reserveBalance = hre.ethers.parseEther("120.0");
        await expect(await getBalance(signingPolicy.address)).to.be.eq(
          reserveBalance,
        );
      });

      it("Should distribute Nat to recipient1", async function () {
        const recipient1Balance = hre.ethers.parseEther("480.0");

        await expect(await getBalance(recipient1.address)).to.be.eq(
          recipient1Balance,
        );
      });

      it("Should distribute wNat to recipient2", async function () {
        // At this point unable to mock contracts with ethers v6
        this.skip();
        const recipient2Balance = hre.ethers.parseEther("160.0");

        await expect(await getBalance(recipient2.address)).to.be.eq(
          recipient2Balance,
        );
      });
    });
  });
});

async function getBalance(address: string) {
  return await hre.ethers.provider.getBalance(address);
}
