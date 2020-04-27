import React, { useState } from "react";
import Web3 from "web3";
import { HelloAbi } from "./abi/HelloAbi.js";
import { SubmissionAbi } from "./abi/SubmissionAbi.js";
import App from "./App";
import ReactDOM from 'react-dom'

import "./App.css";

const web3 = new Web3(Web3.givenProvider);

const contractAddress = "0xEffc90119Ff343B8015eD0ABC0c5A2da7b7F9f4d"; //Contract Address
const HelloContract = new web3.eth.Contract(HelloAbi, contractAddress);
var SubmissionContract;
var propNum;

function Voter() {
  const [prop, setProp] = useState('');
  const [showProp, setShowProp] = useState(false);
  const [showError, setShowError] = useState(false);

  const getProp = async e => {
    e.preventDefault();
    console.log("ASDFASDF")
    try{
      const result = await HelloContract.methods.getPropNum().call();
      console.log("Prop", result);
      const address = result[0]
      propNum = result[1]
      if(propNum===0){
          setShowError(true)
      }else{
          SubmissionContract = new web3.eth.Contract(SubmissionAbi, address);
          const prop = await SubmissionContract.methods.getProp(propNum).call();
          setProp(prop)
          setShowProp(true)     
      }
    }catch(e){
      console.log(e)
      setShowError(true)
    }    
  };

  const castVote = async (e, vote) =>{
    e.preventDefault();
    const accounts = await window.ethereum.enable();
    const account = accounts[0];
    const gas = await SubmissionContract.methods.vote(propNum, vote).estimateGas();
    const result = await SubmissionContract.methods
      .vote(propNum, vote)
      .send({ from: account, gas });
    console.log(result);
  }

function goBack(e) {
    e.preventDefault();
    ReactDOM.render(
      <App />,
      document.getElementById('root')
    );
  }

  return (
    <div className="container"> 
      {showError ? <p>Sorry, there are no propositions available for you to vote on.</p> :
        (showProp ?
          <div className="row">
            <p>"{prop}"</p> 
            <p>Select your vote</p>
            <button onClick={(e) => castVote(e, true)}>True</button>
            <button onClick={(e) => castVote(e, false)}>False</button>
          </div>
        :
          <div>
            <button onClick={getProp}>Get Proposition</button>
          </div>
        ) 
      } 
      <button onClick={goBack}>Return to Home</button>
    </div>
    // <div className="App">
    //   <header className="App-header">
    //     <form onSubmit={setData}>
    //       <label>
    //         Set Data:
    //         <input
    //           type="text"
    //           name="greeting"
    //           value={greeting}
    //           onChange={e => setGreeting(e.target.value)}
    //         />
    //       </label>
    //       <input type="submit" value="Set Data" />
    //     </form>
    //     <br />
    //     <button onClick={getData} type="button">
    //       Get Data
    //     </button>
    //   </header>
    // </div>
  );
}

export default Voter;