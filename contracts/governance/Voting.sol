pragma solidity ^0.4.15;

import '../IDaoBase.sol';

import './IVoting.sol';
import './IProposal.sol';

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Voting is IVoting {
	IDaoBase mc;
	IProposal proposal; 
	uint public minutesToVote;
	bool finishedWithYes = false;
	uint genesis;

	event Voting_CallAction();

	function Voting(IDaoBase _mc, IProposal _proposal, uint _minutesToVote){
		mc = _mc;
		proposal = _proposal;
		minutesToVote = _minutesToVote;
		uint genesis = now;
	}

	function callActionIfEnded() public {
		if(!finishedWithYes && isFinished() && isYes()){
			emit Voting_CallAction();
			finishedWithYes = true;
			// should not be callable again!!!

			// can throw!
			proposal.action(mc, this);
		}
	}

	function isYes()public constant returns(bool){
		var(yesResults, noResults, totalResults) = getFinalResults();
		// TODO: JUST FOR DEBUGGGGG!!!
		return (yesResults > totalResults/2) && (totalResults>1);
	}

	function isFinished() public constant returns(bool){
		// TODO: JUST FOR DEBUGGGGG!!!
		var(yesResults, noResults, totalResults) = getFinalResults();
		return (totalResults>1);
		return false;
	}
}

// TODO: disable token transfers?
contract Voting_SimpleToken is Voting, Ownable {
	address public tokenAddress;

////////
	mapping (address=>bool) votes;

////////
	// we can use _origin instead of tx.origin
	function Voting_SimpleToken(IDaoBase _mc, IProposal _proposal, address _origin, 
						uint _minutesToVote, address _tokenAddress, bytes32 _emptyParam)
						public Voting(_mc, _proposal, _minutesToVote)
	{
		tokenAddress = address(_tokenAddress);

		// TODO: get the balance!!!
		uint tokenAmount = 0;

		internalVote(_origin, true, tokenAmount);
	}

	function vote(bool _yes, uint _tokenAmount) public {
		require(!isFinished());

		internalVote(msg.sender, _yes, _tokenAmount);
	}

	function internalVote(address _who, bool _yes, uint _tokenAmount) internal {
		// TODO: 

		// votes[_who] = _yes;
		
		callActionIfEnded();
	}

	function cancelVoting() public onlyOwner {
		// TODO:
	}

	function getFinalResults() public constant returns(uint yesResults, uint noResults, uint totalResults){
		yesResults = 0;
		noResults = 0;
		totalResults = 0;

		// TODO: 
	}
}