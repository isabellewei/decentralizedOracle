pragma solidity >=0.4.21 <0.7.0;

contract Submission {
    address submitter;
    struct Vote {
        bool vote;
        bool exists;
    }
    struct Proposition {
        uint8 num;
        string question;
        mapping(address => Vote) votes;
    }
    Proposition prop1;
    Proposition prop2;
    uint duration; //in minutes
    

    constructor(string memory _prop1, string memory _prop2, address _submitter, uint _duration) public{
        // Do not set the proposition numbers to be 0 or to be the same
        prop1 = Proposition(1, _prop1);
        prop2 = Proposition(2, _prop2);
        submitter = _submitter;
        duration = _duration;
		// TODO: Take bond +bounty out of submitter’s account
    }

    function getValidPropNum(address voter) public view returns(uint8){
        if(!prop1.votes[voter].exists){
            return prop1.num;
        } else if(!prop2.votes[voter].exists){
            return prop2.num;
        } else{
            return 0;
        }
    }

    function getProp(uint8 prop) public view returns(string memory){
        require(prop==prop1.num || prop == prop2.num, "This is not a valid proposition number");
        if(prop == prop1.num){
            return prop1.question;
        } else if(prop == prop2.num){
            return prop2.question;
        }
    }

    function vote(uint8 prop, bool ans) public{
        require(prop==prop1.num || prop == prop2.num, "This is not a valid proposition number");
        
        if(prop == prop1.num){
            prop1.votes[msg.sender] = Vote(ans, true);
        } else if(prop == prop2.num){
            prop2.votes[msg.sender] = Vote(ans, true);
        }
        // take bond out of voter account
    }

    // Async function closeSubmission(){
    //     Use a scheduler so that the smart contract proactively executes this 
    //     event at the end of the duration

    //     require(converged answers of prop1 and prop2 are opposite)
    //     require(enough votes for both propositions)

    //     Return bond to submitter if requirements are met
    //     Reward voters in agreement and penalize voters in disagreement with majority
    //     Send results of submission to web app to be saved for the Submission History
    //     Remove this submission from list of active submissions
    // }

}