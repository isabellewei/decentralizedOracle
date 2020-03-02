pragma solidity >=0.4.21 <0.7.0;

import "./Submission.sol";

contract Hello {
    Submission[] submissions;
    uint bounty;
    uint bond;

    constructor() public{
        bond = 10;
    }

    function createSubmission(string memory prop1, string memory prop2, uint duration) public payable{
        require(msg.value > bond, "You need to provide a bond and bounty");
        bounty = msg.value - bond;
        Submission newSubmission = new Submission(prop1, prop2, msg.sender, duration);
        submissions.push(newSubmission);
        address(newSubmission).transfer(msg.value);
    } 

    function getPropNum() public view returns(Submission, uint8) {
        // take bond value??
        // Using address of user, pick a random proposition they have not yet voted for
        // Return error if no such proposition exists

        for (uint i = 0; i < submissions.length; i++){
            uint8 prop = Submission(submissions[i]).getValidPropNum(msg.sender);

            if(prop != 0){
                return (submissions[i], prop);
            }
        }
        revert("No valid proposition exists.");
    }

}