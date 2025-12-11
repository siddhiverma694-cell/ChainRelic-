// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title ChainRelic
 * @notice Immutable on-chain relic storage for permanent records, certificates, proofs & metadata.
 * @dev Once a relic is stored, it cannot be edited or deleted. Perfect for compliance,
 *      heritage preservation, provenance and proof-of-existence.
 */
contract ChainRelic {
    address public owner;

    struct Relic {
        address creator;
        string title;
        string dataURI;     // IPFS / Arweave / JSON URI
        uint256 timestamp;
        bytes32 relicHash;
    }

    uint256 public relicCount;
    mapping(uint256 => Relic) public relics;

    event RelicStored(
        uint256 indexed relicId,
        address indexed creator,
        string title,
        bytes32 relicHash,
        uint256 timestamp
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // ─────────────────────────────────────────────
    // ⭐ STORE A NEW RELIC (IMMUTABLE)
    // ─────────────────────────────────────────────
    function storeRelic(string calldata title, string calldata dataURI) external {
        relicCount++;

        bytes32 relicHash = keccak256(
            abi.encodePacked(msg.sender, title, dataURI, block.timestamp, block.number)
        );

        relics[relicCount] = Relic(
            msg.sender,
            title,
            dataURI,
            block.timestamp,
            relicHash
        );

        emit RelicStored(relicCount, msg.sender, title, relicHash, block.timestamp);
    }

    // ─────────────────────────────────────────────
    // ⭐ GET RELIC DETAILS
    // ─────────────────────────────────────────────
    function getRelic(uint256 relicId) external view returns (Relic memory) {
        return relics[relicId];
    }

    // ─────────────────────────────────────────────
    // ⭐ GET ALL RELICS
    // ─────────────────────────────────────────────
    function getAllRelics() external view returns (Relic[] memory) {
        Relic[] memory list = new Relic[](relicCount);
        for (uint256 i = 1; i <= relicCount; i++) {
            list[i - 1] = relics[i];
        }
        return list;
    }
}
