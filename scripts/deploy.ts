import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const SmolUniverseCoin = await ethers.getContractFactory("SmolUniverseCoin");

  console.log("🚀 Deploying SmolUniverseCoin Token contract...");
  // Deploy the contract
  const smolUniverseCoin = await SmolUniverseCoin.deploy();

  console.log("🔄 Waiting for contract deployment confirmation...");
  // Wait for contract deployment confirmation
  await smolUniverseCoin.waitForDeployment();

  // Get deployed contract address
  const contractAddress = await smolUniverseCoin.getAddress();

  console.log(
    `✅ SmolUniverseCoin Token contract deployed to: ${contractAddress}`
  );
}

// Run the script with proper error handling
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("❌ Deployment failed:", error);
    process.exit(1);
  });
