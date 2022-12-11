const {ethers} = require("hardhat");
const chai = require("chai");

describe("Fintrust", () => {
  let fintrustContract;
  let fintrustAddress;
  let fintrustTokenContract;
  let fintrustTokenAddress;
  let deployer;
  let rachel;
  let alex;
  let kamsi;
  let url;
  let amount;
  let provider;

  beforeEach(async () => {    
    const fintToknFactory = await ethers.getContractFactory("FintrustToken");
    fintrustTokenContract = await fintToknFactory.deploy();
    await fintrustTokenContract.deployed();
    fintrustTokenAddress = fintrustTokenContract.address;
    
    const contractFactory = await ethers.getContractFactory("Fintrustv2");
    fintrustContract = await contractFactory.deploy(fintrustTokenAddress);
    await fintrustContract.deployed();
    fintrustAddress = fintrustContract.address;    

    [deployer, alex, rachel, kamsi, ozioma] = await ethers.getSigners();

    url = ethers.utils.formatBytes32String("HelloWorld");
    amount = ethers.utils.parseEther("2");
  });
  describe("Create Campaign", () => {
    it("should create a new campaign", async () => {
      let txn = await fintrustContract.createCampaign(url, amount, 1);

      txn = await txn.wait();

      
await (await fintrustContract.createCampaign(url, amount, 1)).wait();

await (await fintrustContract.createCampaign(url, amount, 1)).wait();

      //console.log(txn.events[0])

      let campaigns = await fintrustContract.getAllCampaigns();
      console.log(campaigns)
    });
  });

  // describe("Deposit", () => {
  //   it("should deposit", async () => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //       alex.address,
  //       rachel.address,
  //       kamsi.address,
  //     ]);

  //     txn = await txn.wait();

  //     //console.log(campaigns)
  //     let depositAmount = hre.ethers.utils.parseEther("50");

  //     let deposit = await fintrustContract
  //       .connect(alex)
  //       .donate(deployer.address, 0, depositAmount, { value: depositAmount });

  //     deposit = await deposit.wait();

  //     let campaigns = await fintrustContract.allCampaigns(deployer.address);

      

  //     // console.log("BAL", balance)
  //      //console.log("Campaigns", campaigns)
  //   });
  // });

  // describe("Request Withdrawal", () => {
  //   it("should create a new campaign", async () => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //       alex.address,
  //       rachel.address,
  //       kamsi.address,
  //     ]);

  //     txn = await txn.wait();

  //     //console.log(campaigns)
  //     let depositAmount = hre.ethers.utils.parseEther("0.5");

  //     let deposit = await fintrustContract
  //       .connect(alex)
  //       .donate(deployer.address, 0, depositAmount, { value: depositAmount });

  //     deposit = await deposit.wait();

  //     let request = await fintrustContract.requestWithdraw(0);
  //     request = await request.wait();

  //     let campaigns = await fintrustContract.allCampaigns(deployer.address);
  //     //console.log("Campaigns:", campaigns)
  //   });
  // });

  // describe("Confirm Withdrawal", () => {
  //   it("should create a new campaign", async () => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //       alex.address,
  //       rachel.address,
  //       kamsi.address,
  //     ]);

  //     txn = await txn.wait();

  //     //console.log(campaigns)
  //     let depositAmount = hre.ethers.utils.parseEther("0.5");

  //     let deposit = await fintrustContract
  //       .connect(alex)
  //       .donate(deployer.address, 0, depositAmount, { value: depositAmount });

  //     deposit = await deposit.wait();

  //     let request = await fintrustContract.requestWithdraw(0);
  //     request = await request.wait();

  //     let confirm = await fintrustContract
  //       .connect(alex)
  //       .confirmWithdraw(deployer.address, 0);

  //     confirm = await confirm.wait();

  //     // let campaigns = await fintrustContract.allCampaigns(deployer.address);
  //     // console.log("Campaigns:", campaigns)

  //     // confirm = await fintrustContract
  //     //   .connect(alex)
  //     //   .rejectWithdraw(deployer.address, 0);

  //     // confirm = await confirm.wait();
  //   });
  // });

  // describe("Reject Withdrawal", () => {
  //   it("should create a new campaign", async () => {
  //      let txn = await fintrustContract.createCampaign(url, amount, [
  //        alex.address,
  //        rachel.address,
  //        kamsi.address,
  //      ]);

  //      txn = await txn.wait();

  //      //console.log(campaigns)
  //      let depositAmount = hre.ethers.utils.parseEther("0.5");

  //      let deposit = await fintrustContract
  //        .connect(alex)
  //        .donate(deployer.address, 0, depositAmount, { value: depositAmount });

  //      deposit = await deposit.wait();

  //      let request = await fintrustContract.requestWithdraw(0);
  //      request = await request.wait();

  //      let confirm = await fintrustContract
  //        .connect(alex)
  //        .rejectWithdraw(deployer.address, 0);

  //      confirm = await confirm.wait();

  //      // let campaigns = await fintrustContract.allCampaigns(deployer.address);
  //     //  console.log("Campaigns:", confirm.events[0]);      
  //   });
  // });

  // describe("Withdraw", () => {
  //   it("should create a new campaign", () => {

  //   });
  // });

  // describe("GetACampaign", () => {
  //   it("should create a new campaign", async() => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //       alex.address,
  //       rachel.address,
  //       kamsi.address,
  //     ]);

  //     txn = await txn.wait();

  //     let campaign = await fintrustContract.getCampaign(0, deployer.address);
  //    // console.log("CAMPAIGN:", campaign)
  //   });
  // });

  // describe("GetAllCreatedCampaigns", () => {
  //   it("should create a new campaign", () => {});
  // });

  // describe("getAllSignatoryCampaigns", () => {
  //   it("should create a new campaign", async () => {
  //      let txn = await fintrustContract.createCampaign(url, amount, [
  //        alex.address,
  //        rachel.address,
  //        kamsi.address,
  //      ]);

  //      txn = await txn.wait();

  //      //console.log(campaigns)
  //      let depositAmount = hre.ethers.utils.parseEther("0.5");

  //      let deposit = await fintrustContract
  //        .connect(alex)
  //        .donate(deployer.address, 0, depositAmount, { value: depositAmount });

  //      deposit = await deposit.wait();

  //      let request = await fintrustContract.requestWithdraw(0);
  //      request = await request.wait();

  //      let confirm = await fintrustContract
  //        .connect(alex)
  //        .rejectWithdraw(deployer.address, 0);

  //      confirm = await confirm.wait();

  //      // let campaigns = await fintrustContract.allCampaigns(deployer.address);
  //      // console.log("Campaigns:", confirm.events[0]);      
  //   });
  // });

  // describe("Withdraw", () => {
  //   it("should create a new campaign", async () => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //        alex.address,
  //        rachel.address,
  //        kamsi.address,
  //      ]);

  //      txn = await txn.wait();

  //      //console.log(campaigns)
  //      let depositAmount = hre.ethers.utils.parseEther("20");
  //      let withdra1Amount = hre.ethers.utils.parseEther("20");

  //      let deposit = await fintrustContract
  //        .connect(alex)
  //        .donate(deployer.address, 0, depositAmount, { value: depositAmount });

  //      deposit = await deposit.wait();

  //      let request = await fintrustContract.requestWithdraw(0);
  //      request = await request.wait();

  //       let confirm = await fintrustContract
  //        .connect(alex)
  //        .confirmWithdraw(deployer.address, 0);

  //      confirm = await confirm.wait();

  //      confirm = await fintrustContract
  //        .connect(rachel)
  //        .confirmWithdraw(deployer.address, 0);

  //      confirm = await confirm.wait();

  //      confirm = await fintrustContract
  //        .connect(kamsi)
  //        .confirmWithdraw(deployer.address, 0);

  //      confirm = await confirm.wait();
  //      //console.log(await deployer.getBalance(), "bal before");

  //      let withdraw = await fintrustContract.withdraw(0, withdra1Amount);

  //      withdraw = await withdraw.wait();

  //      //console.log(await deployer.getBalance(), "bal after")

  //      //console.log(await alex.getBalance());


  //      // let campaigns = await fintrustContract.allCampaigns(deployer.address);
  //     //  console.log("Campaigns:", confirm.events[0]);  
  //   });
  // });

  // describe("GetACampaign", () => {
  //   it("should create a new campaign", async() => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //       alex.address,
  //       rachel.address,
  //       kamsi.address,
  //     ]);

  //      let txn2 = await fintrustContract.connect(alex).createCampaign(url, amount, [
  //        deployer.address,
  //        rachel.address,
  //        kamsi.address,
  //      ]);

  //       let txn3 = await fintrustContract.connect(rachel).createCampaign(url, amount, [
  //         alex.address,
  //         deployer.address,
  //         kamsi.address,
  //       ]);

  //     txn = await txn.wait();
  //     txn2 = await txn2.wait();
  //     txn3 = await txn3.wait();


  //     let campaign = await fintrustContract.getAllCampaigns();
  //    console.log("CAMPAIGN:", campaign)
  //   });
  // });

  // describe("GetACampaign", () => {
  //   it("should create a new campaign", async () => {
  //     let txn = await fintrustContract.createCampaign(url, amount, [
  //       alex.address,
  //       rachel.address,
  //       kamsi.address,
  //     ]);

  //     txn = await txn.wait();

  //     let campaign = await fintrustContract.getCampaign(0, deployer.address);
  //     // console.log("CAMPAIGN:", campaign)
  //   });
  // });

  // describe("getAllWithdrawRequest", () => {
  //   it("should create a new campaign", () => {});
  // });
});
