// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "./libs/UniversalERC20.sol";

import "./interfaces/ISlashCustomPlugin.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ScoreTxExtention is ISlashCustomPlugin, Ownable {
    using UniversalERC20 for IERC20;

    address public contractOwner;
    address public scoreBoard;

    function receivePayment(
        address receiveToken,
        uint256 amount,
        bytes calldata,
        string calldata,
        bytes calldata  reserved
    ) external payable override {
        require(amount > 0, "invalid amount");
        
        IERC20(receiveToken).universalTransferFrom(msg.sender, owner(), amount);

        scoreTransaction(msg.sender, receiveToken, amount);
    }

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

    //送金先の変更
    function updateScoreContractAddress(address _scoreContractAddress) external {
        require(msg.sender==contractOwner);
        scoreBoard = _scoreContractAddress;
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
    function supportSlashExtensionInterface()
        external
        pure
        override
        returns (uint8)
    {
        return 2;
    }

    //所定のコントラクトアドレスに対してTxの内容を書き込む
    function scoreTransaction (
        address _sender,
        address _receiveToken, 
        uint256 _amount
    ) internal {
        // 書き込むメッセージを定義する
        bytes memory scoreMsg = abi.encodePacked(
            '{"paymentFrom": "',
            Strings.toHexString(uint160(_sender), 20),
            '", "Token":"',
            Strings.toHexString(uint160(_receiveToken), 20),
            '", "amount": ',
            Strings.toHexString(_amount),
            '"}'
        );
        // noteに上記メッセージを含んだ状態で0ethの送金txを実行する
        (bool success, ) = (scoreBoard).call{
            value: 0 wei, 
            gas: 30000
        }(scoreMsg);
        require(success, "Failed to send ether");
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    /*
    function supportsInterface(
        bytes4 
    ) public view virtual override returns (bool) {
        return false;
    }
    */
}