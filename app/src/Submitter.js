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

function Voter() {
  const [prop1, setProp1] = useState('');
  const [prop2, setProp2] = useState('');
  const [showForm, setShowForm] = useState(true)

  const setSubmission = async e => {
    e.preventDefault();
    const accounts = await window.ethereum.enable();
    const account = accounts[0];
    const gas = await HelloContract.methods.createSubmission(prop1, prop2).estimateGas();
    const result = await HelloContract.methods
      .createSubmission(prop1, prop2)
      .send({ from: account, gas });
    console.log(result);
    setShowForm(false)
  };

  function formAgain(e) {
    e.preventDefault();
    setShowForm(true)
  }   

  function goBack(e) {
    e.preventDefault();
    ReactDOM.render(
      <App />,
      document.getElementById('root')
    );
  }   

  return (
    <div>   
      {showForm ? 
        <form onSubmit={setSubmission}>
          <label>
            Proposition 1:
            <input
              type="text"
              name="prop1"
              value={prop1}
              onChange={e => setProp1(e.target.value)}
            />
          </label>
          <label>
            Proposition 2:
            <input
              type="text"
              name="prop2"
              value={prop2}
              onChange={e => setProp2(e.target.value)}
            />
          </label>
          <input type="submit" value="Create Submission" />
        </form>
      :
        <button onClick={formAgain}>Create another submission</button>
      }
      <button onClick={goBack}>Return to Home</button>
    </div>
  );
}

export default Voter;