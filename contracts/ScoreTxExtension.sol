// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

//RecordScore.solを読み込む
interface IfRecordScore {
    function scoreTransaction(
        address sender,
        address receiveToken, 
        uint256 amount,
        string memory paymentId,
        string memory optional
    ) external returns (uint256);
}

contract ScoreTxExtention is ISlashCustomPlugin, Ownable {
    using SafeMath for uint256;
    using UniversalERC20 for IERC20;
    address public contractOwner;
    address public scoreBoard;

    //mapping(string => uint256) public purchaseInfo;

    //デプロイ時の初期設定(各パラメータの初期値も変更する)
    constructor() {
        contractOwner = msg.sender;
        scoreBoard = 0x0000000000000000000000000000000000000000;
    }

    //オーナーの変更
    function updateContractOwner(address _newContractOwner) external {
        require(msg.sender == contractOwner, "you don't have a permission (Error : 403)");
        contractOwner = _newContractOwner;
    }

    //呼び出す関数の変更
    function updateScoreContractAddress(address _scoreContractAddress) external {
        require(msg.sender==contractOwner);
        scoreBoard = _scoreContractAddress;
    }

    function receivePayment(
        address receiveToken, 
        uint256 amount,
        string memory paymentId,
        string memory optional
    ) external payable override {
        require(amount > 0, "invalid amount");
        require(receiveToken != address(0), "invalid token");

        IERC20(receiveToken).universalTransferFrom(
            msg.sender,
            owner(),
            amount
        );
        // ToDo: 拡張機能として外付けする処理を実行する
        afterReceived(msg.sender, receiveToken, amount, paymentId, optional);
    }

    //ToDo: 送金処理の実装(ここに拡張機能で呼び出したい処理を書き込む)
    //-> Score書き込みを呼び出して、返り値を返す
    function afterReceived(
        address sender,
        address receiveToken, 
        uint256 amount,
        string memory paymentId,
        string memory optional
    ) internal {
        IfRecordScore _recordScore = IfRecordScore(scoreBoard);
        _recordScore.scoreTransaction(
            sender,
            receiveToken, 
            amount,
            paymentId,
            optional
        );
    }

    function withdrawToken(address tokenContract) external onlyOwner {
        require(
            IERC20(tokenContract).universalBalanceOf(address(this)) > 0, 
            "balance is zero"
        );

        IERC20(tokenContract).universalTransfer(
            msg.sender,
            IERC20(tokenContract).universalBalanceOf(address(this))
        );

        emit TokenWithdrawn(
            tokenContract, 
            IERC20(tokenContract).universalBalanceOf(address(this))
        );

    }
    event TokenWithdrawn(address tokenContract, uint256 amount);

    /**
     * @dev Check if the contract is Slash Plugin
     *
     * Requirement
     * - Implement this function in the contract
     * - Return true
     */
    function supportSlashExtensionInterface() external pure override returns (bool) {
        return true;
    }
}