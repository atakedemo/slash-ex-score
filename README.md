# Slash Extention : キャンペーン別スコアリング

### セットアップ
```shell
OpenZepplin
npm install @openzeppelin/contracts
環境変数の利用のため
npm install dotenv
```

### コードサンプル（slashの公式ドキュメントからの引用）
https://github.com/slash-fi-public/slash-extension-nft-minting/tree/main/contracts

### 各コードの役割
* ScoreTxExtension.sol  -> 決済時に拡張機能として呼び出されるコード
* RecordScore           -> 実際にスコアを書くコード（上記コードから呼び出される）

### 以下、Hardhatの基本的な使い方
This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```
