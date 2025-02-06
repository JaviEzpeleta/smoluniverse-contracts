import { ethers } from "hardhat";

async function main(): Promise<void> {
  // Obtén la dirección del verificador desde la variable de entorno
  const verifierAddress = process.env.DEPLOYER_WALLET_ADDRESS;
  if (!verifierAddress) {
    console.error(
      "ERROR: Por favor, establece la variable VERIFIER_ADDRESS en tu .env"
    );
    process.exit(1);
  }

  console.log(
    "¡Hostia, colega! Desplegando el contrato AVSTransfer a Base Sepolia..."
  );

  // Obtén la factoría del contrato AVSTransfer
  const AVSTransferFactory = await ethers.getContractFactory("AVSTransfer");
  const avsTransferContract = await AVSTransferFactory.deploy(verifierAddress);

  // Espera a que se mine el bloque de despliegue
  await avsTransferContract.waitForDeployment();

  console.log(
    "¡Mira, ya está desplegado, joder! Contrato AVSTransfer en:",
    await avsTransferContract.getAddress()
  );
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error("Error en el despliegue:", error);
    process.exit(1);
  });
