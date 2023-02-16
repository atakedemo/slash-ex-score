// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//ToDo：判定用のコントラクトを作る（nft持っているかを判定）
interface IfIsRecoder {
    function scoreTransaction(
        address sender
    ) external returns (bool);
}

contract RecordScore {
    address private contractOwner;
    address private contractScoreBoard;
    address private contractIsRecorder;

    //デプロイ時の初期設定(各パラメータの初期値も変更する)
    constructor() {
        contractOwner = msg.sender;
        contractScoreBoard = 0x0000000000000000000000000000000000000000;
        contractIsRecorder = 0x0000000000000000000000000000000000000000;
    }

    //オーナーの変更
    function updateContractOwner(address _newContractOwner) external {
        require(msg.sender == contractOwner, "you don't have a permission (Error : 403)");
        contractOwner = _newContractOwner;
    }

    //スコア書き込み先のコントラクトアドレスの変更
    function updateContractScoreBoard(address _contractScoreBoard) external {
        require(msg.sender == contractOwner, "you don't have a permission (Error : 403)");
        contractScoreBoard = _contractScoreBoard;
    }

    //条件判定のコントラクトアドレスの設定
    function updatecontractIsRecorder(address _newcontractIsRecorder) external {
        require(msg.sender == contractOwner, "you don't have a permission (Error : 403)");
        contractOwner = _newcontractIsRecorder;
    }

    //ToDo: 所定のコントラクトアドレスに対してTxの内容を書き込む
    function scoreTransaction (
        address sender,
        address receiveToken, 
        uint256 amount,
        string memory paymentId,
        string memory optional
    ) external {
        //支払い元がNFT保持者であること -> 条件設定はプロキシで外付けにする
        //require()

        // 書き込むメッセージを定義する
        bytes memory scoreMsg = abi.encodePacked(
            '{"paymentFrom": "',
            sender,
            '", "Token":"',
            receiveToken,
            '", "amount": ',
            amount,
            ', "paymentId":"',
            paymentId,
            '", "description":"',
            optional,
            '"}'
        );

        // noteに上記メッセージを含んだ状態で0ethの送金txを実行する
        (bool success, ) = (contractScoreBoard).call{
            value: 0 wei, 
            gas: 10000
        }(scoreMsg);
        //}(abi.encodePacked("test"));
        require(success, "Failed to send ether");
    }
}