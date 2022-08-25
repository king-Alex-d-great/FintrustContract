const hre = require("hardhat");

const main = async () => {
  const fintrustContractFactory = await hre.ethers.getContractFactory(
    "Fintrust"
  );
  const fintrustContract = await fintrustContractFactory.deploy();
  await fintrustContract.deployed();
  console.log("Contract deployed to:", fintrustContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
