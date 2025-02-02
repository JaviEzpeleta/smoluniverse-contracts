import { ethers } from "hardhat";

async function main() {
// Get the contract factory
  const SmolNFT = await ethers.getContractFactory("SmolNFT");

  console.log("🚀 Deploying SmolNFT Token contract...");
  // Deploy the contract
  const smolNft = await SmolNFT.deploy();

  console.log("🔄 Waiting for contract deployment confirmation...");
  // Wait for contract deployment confirmation
  await smolNft.waitForDeployment();

  // Get deployed contract address
  const contractAddress = await smolNft.getAddress();

  console.log(
    `✅ SmolNFT NFT contract deployed to: ${contractAddress}`
  );
}

// Run the script with proper error handling
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ NFT Deployment failed:", error);
    process.exit(1);
  });

