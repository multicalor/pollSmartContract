// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/utils/Counters.sol";
import './Vote.sol';


contract PollFactory {

    using Counters for Counters.Counter;
    Counters.Counter private pollID;
    
    enum Status { IN_PROGRESS, DONE }
    
    
    struct Poll {
        uint voteID;
        address owner;
        string [2] info;
        Status status;
        Vote vote;
    }
    
    struct Info {
        uint voteID;
        string [2] info;
        Status status;
    }
    
    mapping(uint => Poll) private pollsByID;
    

    mapping(address => Info []) private creatorPolls;
    
   
    mapping(address => Info []) private voterPolls;
    
    event StartVote(address indexed from, uint voteID);
    event EndVote(address indexed from, uint[3] value, uint pollID);
    event NewVoter(address indexed from, address indexed to, uint pollID);
    event Voted(address indexed from, uint pollID);
    
    
    function getPollInfoByID(uint _pollID) public view returns ( Info memory ) {
        
        return Info({
            
            voteID: pollsByID[_pollID].voteID,
            info: pollsByID[_pollID].info,
            status : pollsByID[_pollID].status
            
            });
        
        }
    

    function createPoll(string memory _title, string memory _description) public returns(uint ID ) {
        
        pollsByID[pollID.current()] = Poll({
            voteID : pollID.current(),
            owner: msg.sender,
            info : [_title, _description],
            status : Status.IN_PROGRESS,
            vote : new Vote(_title, _description)
        });
        
        
        creatorPolls[msg.sender].push(getPollInfoByID(pollID.current()));
        
        
        pollID.increment();
        
        emit StartVote(msg.sender, pollID.current());

        return pollID.current();
        
    }
    

    
    function addVoterToPoll(address _voter, uint _pollID) public {
        
        require (pollsByID[_pollID].voteID == _pollID, "Voting is not created yet");
        
        require (pollsByID[_pollID].status == Status.IN_PROGRESS, "Voting has already ended");
        
        require (pollsByID[_pollID].owner == msg.sender, "Only the owner can use this method");
        
        pollsByID[_pollID].vote.addVoter(_voter);
    
        voterPolls[_voter].push(getPollInfoByID(_pollID));

        emit NewVoter(msg.sender, _voter, _pollID);
        
    }


    function getVoterPolls () public view returns (Info[] memory) {
        
        require (voterPolls[msg.sender].length > 0, "You are not yet voting");

        return voterPolls[msg.sender];
        
    }
    
    
    function getCreatedPolls() public view returns (Info[] memory) { 

        require (creatorPolls[msg.sender].length > 0, "You haven't created any polls yet");
                
        return creatorPolls[msg.sender];
        
        
    }


  
    function toVote (Vote.choices _choice , uint _pollID) public {
        
        require (pollsByID[_pollID].voteID == _pollID, "Voting is not created yet");
        
        require (pollsByID[_pollID].status == Status.IN_PROGRESS, "Voting has already ended");
        
        pollsByID[_pollID].vote.vote(msg.sender, _choice );
        
        emit Voted(msg.sender, _pollID);
    }
    
    
    
    function getPollResults(uint _pollID) public view returns (uint[3] memory) {
        
        require (pollsByID[_pollID].voteID == _pollID, "Voting is not created yet");

        require (pollsByID[_pollID].status == Status.DONE, "Voting is not over yet");    
        
        return pollsByID[_pollID].vote.getResults();

    }
    
    
    function endPoll(uint _pollID) public {
   
        require (pollsByID[_pollID].voteID == _pollID, "Voting is not created yet");
        
        require (pollsByID[_pollID].owner == msg.sender, "Only the owner can use this method");
        
        pollsByID[_pollID].vote.endVote();
        
        pollsByID[_pollID].status = Status.DONE;

        uint[3] memory results =  getPollResults(_pollID);

        emit EndVote(msg.sender, results, _pollID);

    }
     
  }