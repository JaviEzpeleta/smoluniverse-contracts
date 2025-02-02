import { ethers } from "hardhat";

async function main() {
  const paymentTokenAddress = "0x877b0ffAce077ce8d953626cE1c0AF390D429e56";

  const SmolMarketplace = await ethers.getContractFactory("SmolMarketplace");
  console.log("🚀 Deploying SmolMarketplace contract...");

  // Pasa la dirección del token de pago al constructor
  const smolMarketplace = await SmolMarketplace.deploy(paymentTokenAddress);

  console.log("🔄 Waiting for contract deployment confirmation...");
  await smolMarketplace.waitForDeployment();

  // Get deployed contract address
  const contractAddress = await smolMarketplace.getAddress();

  console.log(`✅ SmolMarketplace contract deployed to: ${contractAddress}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
