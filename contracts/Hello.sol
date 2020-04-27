pragma solidity >=0.4.21 <0.7.0;

import "./Submission.sol";

contract Hello {
    Submission[] submissions;
    Submission[] closedSubs;
    uint constant bondBounty = 20 finney; //bond=5, minimum bounty=15

    function closeSubmissions() private{
        uint i = 0;
        while(i < submissions.length){
            Submission sub = Submission(submissions[i]);
            uint close = sub.closeTime();

            if(close * (1 minutes) >= now){
                sub.closeSubmission();
                closedSubs.push(submissions[i]);
                submissions[i] = submissions[submissions.length - 1];
                delete submissions[submissions.length - 1];
                submissions.length--;
                i--;
  
            }
            i++;
        }
    }

    function createSubmission(string memory prop1, string memory prop2, uint duration) public payable{
        closeSubmissions();
        require(msg.value > bondBounty, "You need to provide a bond and bounty");
        Submission newSubmission = (new Submission).value(msg.value)(prop1, prop2, msg.sender, duration);
        submissions.push(newSubmission);
        address(newSubmission).call.value(msg.value)("");
    } 

    function getPropNum() public returns(Submission, uint8) {
        closeSubmissions();
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

    function() external payable { 
      // fallback function to receive all payments
    }

}