import { ethers } from "hardhat";

async function main() {
  console.log("🚀 Deploying SmolNFTsCollection begins!");

  // Get the contract factory
  const SmolNFTsCollection = await ethers.getContractFactory(
    "SmolNFTsCollection"
  );

  console.log("🔄 Deploying SmolNFTsCollection...");

  // Deploy the contract
  const smolNFTsCollection = await SmolNFTsCollection.deploy();

  console.log("🔄 Waiting for SmolNFTsCollection deployment...");

  // Wait for the contract to be deployed
  await smolNFTsCollection.waitForDeployment();

  console.log("🔄 SmolNFTsCollection deployed!");

  // Log the contract address
  console.log(
    "SmolNFTsCollection deployed to:",
    await smolNFTsCollection.getAddress()
  );
}

// Run the deployment script
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
