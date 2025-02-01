import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const SmolSimCoin = await ethers.getContractFactory("SmolSimCoin");

  // Deploy the contract
  const smolSimCoin = await SmolSimCoin.deploy();

  // Wait for contract deployment confirmation
  await smolSimCoin.waitForDeployment();

  // Get deployed contract address
  const contractAddress = await smolSimCoin.getAddress();

  console.log(`✅ SmolSimCoin deployed to: ${contractAddress}`);
}

// Run the script with proper error handling
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
