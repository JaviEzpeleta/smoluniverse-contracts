// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title AVSTransfer
 * @dev Contrato AVS para realizar transferencias verificadas de tokens entre clones.
 * Se requiere una firma autorizada del verificador para ejecutar la transferencia.
 */
contract AVSTransfer {
    using ECDSA for bytes32;

    // Dirección del verificador autorizado (por ejemplo, el deployer o wallet AVS)
    address public verifier;

    // Mapeo para evitar replays de una misma transferencia
    mapping(bytes32 => bool) public executedTransfers;

    // Evento emitido cuando se ejecuta una transferencia verificada
    event AVSTransferExecuted(
        address indexed token,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes32 actionHash,
        bytes signature
    );

    /**
     * @dev Constructor que establece la dirección del verificador autorizado.
     * @param _verifier La dirección autorizada para firmar transferencias AVS.
     */
    constructor(address _verifier) {
        verifier = _verifier;
    }

    /**
     * @dev Ejecuta una transferencia de tokens entre clones de forma verificada.
     * Requiere una firma autorizada del verificador.
     * @param token Dirección del contrato ERC20.
     * @param from Dirección del emisor (debe haber aprobado este contrato).
     * @param to Dirección del receptor.
     * @param amount Cantidad de tokens a transferir.
     * @param nonce Número único para evitar replays.
     * @param signature Firma generada off-chain por el verificador.
     */
    function avsTransfer(
        address token,
        address from,
        address to,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external {
        // Construye el hash del mensaje con los parámetros críticos
        bytes32 messageHash = keccak256(
            abi.encodePacked(token, from, to, amount, nonce, address(this))
        );

        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
        // Recupera la dirección que firmó el mensaje
        address recoveredSigner = ECDSA.recover(ethSignedMessageHash, signature);
        require(recoveredSigner == verifier, "AVSTransfer: firma no valida");

        // Evita ataques de replay asegurando que la acción no se ejecute más de una vez
        require(!executedTransfers[messageHash], "AVSTransfer: transferencia ya ejecutada");
        executedTransfers[messageHash] = true;

        // Ejecuta la transferencia de tokens.
        // Nota: 'from' debe haber aprobado previamente este contrato para mover sus tokens.
        bool success = IERC20(token).transferFrom(from, to, amount);
        require(success, "AVSTransfer: fallo en la transferencia");

        emit AVSTransferExecuted(token, from, to, amount, messageHash, signature);
    }
}
