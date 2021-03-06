pragma solidity ^0.4.24;

import "./RLP.sol";


/**
 * @dev base on https://github.com/omisego/plasma-mvp/blob/master/plasma/root_chain/contracts/PlasmaRLP.sol
 */
library PlasmaRLP {

    struct exitingTx {
        bytes32 snapshotId;
        uint256 inputCount;
    }

    struct exitingContract {
        address token;
        address exitor;
        uint256 weight;
        bytes cont;
    }

    /* Public Functions */

    function getUtxoPos(bytes memory challengingTxBytes, uint256 oIndex)
        internal
        constant
        returns (uint256)
    {
        var txList = RLP.toList(RLP.toRlpItem(challengingTxBytes));
        uint256 oIndexShift = oIndex * 3;
        return
            RLP.toUint(txList[0 + oIndexShift]) +
            RLP.toUint(txList[1 + oIndexShift]) +
            RLP.toUint(txList[2 + oIndexShift]);
    }

    function createExitingTx(bytes memory exitingTxBytes, uint256 oindex)
        internal
        constant
        returns (exitingTx)
    {
        var txList = RLP.toList(RLP.toRlpItem(exitingTxBytes));
        return exitingTx({
            snapshotId: bytesToBytes32(RLP.toBytes(txList[8 + 2 * oindex])),
            inputCount: RLP.toUint(txList[0]) * RLP.toUint(txList[3])
        });
    }

    function createExitingContract(bytes memory snapshot)
        internal
        constant
        returns (exitingContract)
    {
        var snapshotList = RLP.toList(RLP.toRlpItem(snapshot));
        return exitingContract({
            token: RLP.toAddress(snapshotList[1]),
            // owner
            exitor: RLP.toAddress(snapshotList[2]),
            // weight
            weight: RLP.toUint(snapshotList[3]),
            // contract
            cont: RLP.toBytes(snapshotList[4])
        });
    }

    function validateOwn(bytes memory sendContractBytes)
        internal
        constant
        returns (address)
    {
        var sendContract = RLP.toList(RLP.toRlpItem(sendContractBytes));
        // TODO: validate send contract
        return RLP.toAddress(sendContract[2]);
    }

    function bytesToBytes32(bytes b) private pure returns (bytes32) {
        bytes32 out;

        for (uint i = 0; i < 32; i++) {
            out |= bytes32(b[i] & 0xFF) >> (i * 8);
        }
        return out;
    }

}
