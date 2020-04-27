pragma solidity >=0.4.21 <0.7.0;

contract Submission {
    address submitter;
    address mainContract;
    struct Vote {
        bool vote;
        bool exists;
    }
    struct Proposition {
        uint8 num;
        string question;
        mapping(address => Vote) votes;
        address[] voters;
        uint trueVotes;
    }
    Proposition internal prop1;
    Proposition internal prop2;
    uint public closeTime; //in minutes
    uint constant voterBond = 5 finney;
    uint constant submitterBond = 5 finney;
    uint bounty;

    enum Status {SUCCESS, FAIL, VOID}
    Status closedStatus;

    constructor(string memory _prop1, string memory _prop2, address _submitter, uint _duration) public payable{
        // Do not set the proposition numbers to be 0 or to be the same
        prop1.num = 1;
        prop1.question = _prop1;
        prop1.trueVotes = 0;
        prop2.num = 2;
        prop2.question = _prop2;
        prop2.trueVotes = 0;
        submitter = _submitter;
        mainContract = msg.sender;
        closeTime = now + _duration;
        bounty = msg.value - submitterBond;
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

    function vote(uint8 prop, bool ans) public payable{
        require(prop==prop1.num || prop == prop2.num, "This is not a valid proposition number");
        require(msg.value > voterBond, "You need to provide a bond");
        
        if(prop == prop1.num){
            prop1.votes[msg.sender] = Vote(ans, true);
            prop1.voters.push(msg.sender);
            if(ans){
                prop1.trueVotes ++;
            }
        } else if(prop == prop2.num){
            prop2.votes[msg.sender] = Vote(ans, true);
            prop2.voters.push(msg.sender);
            if(ans){
                prop2.trueVotes ++;
            }
        }
    }

    function closeSubmission() external{
        bool prop1Res = (prop1.trueVotes/prop1.voters.length)*2 > 1;
        bool prop2Res = (prop2.trueVotes/prop2.voters.length)*2 > 1;
        bool propTie = (prop1.trueVotes/prop1.voters.length)*2 == 1 || (prop2.trueVotes/prop2.voters.length)*2 == 1;
        bool enoughVotes = (prop1.voters.length > 20)&&(prop2.voters.length > 20);
        uint i;

        if(propTie || !enoughVotes){
            closedStatus = Status.VOID;
            for(i = 0; i<prop1.voters.length; i++) {
                prop1.voters[i].call.value(voterBond)("");
            }
            for(i = 0; i<prop2.voters.length; i++) {
                prop2.voters[i].call.value(voterBond)("");
            }
            submitter.call.value(bounty+submitterBond)("");
        }else if(prop1Res!=prop2Res){
            closedStatus = Status.SUCCESS;
            uint totalGoodVotes = 0;
            if(prop1Res){
                totalGoodVotes += prop1.trueVotes;
            }else{
                totalGoodVotes += prop1.voters.length - prop1.trueVotes;
            }
            if(prop2Res){
                totalGoodVotes += prop2.trueVotes;
            }else{
                totalGoodVotes += prop2.voters.length - prop2.trueVotes;
            }
            uint reward = bounty / totalGoodVotes;

            for(i = 0; i<prop1.voters.length; i++) {
                if(prop1.votes[prop1.voters[i]].vote==prop1Res){
                    prop1.voters[i].call.value(reward+voterBond)("");
                } else if(reward < voterBond){
                    prop1.voters[i].call.value(voterBond-reward)("");
                }
            }
            for(i = 0; i<prop2.voters.length; i++) {
                if(prop2.votes[prop2.voters[i]].vote==prop2Res){
                    prop2.voters[i].call.value(reward+voterBond)("");
                }else if(reward < voterBond){
                    prop2.voters[i].call.value(voterBond-reward)("");
                }
            }
                submitter.call.value(submitterBond)("");
                mainContract.call.value(address(this).balance)("");
        }else{
            closedStatus = Status.FAIL;
            for(i = 0; i<prop1.voters.length; i++) {
                prop1.voters[i].call.value(voterBond)("");
            }
            for(i = 0; i<prop2.voters.length; i++) {
                prop2.voters[i].call.value(voterBond)("");
            }
            submitter.call.value(bounty)("");
            mainContract.call.value(address(this).balance)("");
        }
    }

}