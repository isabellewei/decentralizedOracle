import React, { useState } from "react";
import Voter from "./Voter";
import Submitter from "./Submitter";
import ReactDOM from 'react-dom'

import "./App.css";

function App() {
  function handleVoterClick(e) {
    e.preventDefault();
    ReactDOM.render(
      <Voter />,
      document.getElementById('root')
    );
  }
  
  function handleSubmitterClick(e) {
    e.preventDefault();
    ReactDOM.render(
      <Submitter />,
      document.getElementById('root')
    );
  }
  
  return (
    <div>
      <p>Choose your role</p>
      <button onClick={handleVoterClick}>
        Voter
      </button>
      <button onClick={handleSubmitterClick}>
        Submitter
      </button>
    </div>
  );
}

export default App;