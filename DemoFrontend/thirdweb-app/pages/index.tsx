import { 
  ConnectWallet,
} from "@thirdweb-dev/react";
import type { NextPage } from "next";
import styles from "../styles/Home.module.css";
import contract_score from '../abi/RecordScore.json';
import contract_tx_extention from '../abi/ScoreTxExtention.json'
import contract_sample_nft from '../abi/SampleNFT.json'
import { ethers } from 'ethers';

//Contracts Info
const contractAddress_score = "0xc1b56d19cc7d90c2fb9728497c6432313393bd44";
const contractAddress_tx_extention = "0xdA7915297188E7a6418742DCFf183C63133DE239";
const contractAddress_sample_nft = "0x082FE402E1a47826bB3c3Da016d27FDa4C3642Bb";
const abi_score = contract_score.abi;
const abi_tx_extention = contract_tx_extention.abi;
const abi_sample_nft = contract_sample_nft.abi


const Home: NextPage = () => {
  const contractSendTx = async () => {
    const { ethereum } = window;
    const provider = new ethers.providers.Web3Provider(ethereum);
    const signer = provider.getSigner();
    const tgtContract = new ethers.Contract(contractAddress_score, abi_score , signer);
    let txn = await tgtContract.scoreTransaction(
      "0x7b718d4ce6ca83536660a314639559f3d3f6e9e3",
      "0x7b718d4ce6ca83536660a314639559f3d3f6e9e3",
      100,
      "string:paymentId",
      "string:optional",
    )

    console.log("Mining... please wait");
    await txn.wait();

    console.log(`See transaction: ${txn.hash}`);
  }

  const contractTxExtention = async () => {
    const { ethereum } = window;
    const provider = new ethers.providers.Web3Provider(ethereum);
    const signer = provider.getSigner();
    const tgtContract = new ethers.Contract(contractAddress_tx_extention, abi_tx_extention , signer);
    let txn = await tgtContract.updateScoreContractAddress("0xdedb545e86e421ef9f26484fd49150fef3f8ccbf", {
      gasLimit: 160000,
    })
    console.log("Mining... please wait");
    await txn.wait();

    console.log(`See transaction: ${txn.hash}`);
  }

  //テスト用のユーティリティNFTを発行
  const contractMintNft = async () => {
    const { ethereum } = window;
    const provider = new ethers.providers.Web3Provider(ethereum);
    const signer = provider.getSigner();
    const tgtContract = new ethers.Contract(contractAddress_sample_nft, abi_sample_nft , signer);
    let txn = await tgtContract.mintNFT(
      "0x7b718D4Ce6ca83536660a314639559F3d3f6e9e3", 
      "https://web3core.4attraem.com/nft_metadata/1.json"
    )
    console.log("Mining... please wait");
    await txn.wait();

    console.log(`See transaction: ${txn.hash}`);
  }

  return (
    <div className={styles.container}>
      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to <a href="http://thirdweb.com/">thirdweb</a>!
        </h1>

        <p className={styles.description}>
          Get started by configuring your desired network in{" "}
          <code className={styles.code}>pages/_app.tsx</code>, then modify the{" "}
          <code className={styles.code}>pages/index.tsx</code> file!
        </p>

        <div className={styles.connect}>
          <ConnectWallet />
        </div>
        <div className={styles.connect}>
          <h2>Test Send Tx</h2>
          <form
            onSubmit={ async (e) => {
              e.preventDefault();
              e.stopPropagation();
              contractSendTx()
            }}
          >
            <button type="submit">Test</button>
          </form>
        </div>
        <div className={styles.connect}>
          <h2>Test Tx Etention</h2>
          <form
            onSubmit={ async (e) => {
              e.preventDefault();
              e.stopPropagation();
              contractTxExtention()
            }}
          >
            <button type="submit">Test</button>
          </form>
        </div>

        <div className={styles.connect}>
          <h2>Mint NFT</h2>
          <form
            onSubmit={ async (e) => {
              e.preventDefault();
              e.stopPropagation();
              contractMintNft()
            }}
          >
            <button type="submit">Test</button>
          </form>
        </div>

      </main>
    </div>
  );
};

export default Home;
