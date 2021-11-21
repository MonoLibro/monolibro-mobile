typedef VotingCallback = void Function();

class VotingSession{
  String votingID;
  int userCount;
  VotingCallback successCallback;
  VotingCallback failCallback;
  VotingCallback voteCallback;

  int votedCount = 0;
  int status = 0;

  VotingSession(this.votingID, this.successCallback, this.failCallback, this.voteCallback, this.userCount);

  void vote(){
    if (status == 1) return;
    voteCallback();
    votedCount ++;
    if (hasVotePassed()){
      status = 1;
      successCallback();
    }
  }

  void newVote(){
    if (status == 1) return;
    votedCount ++;
    if (hasVotePassed()){
      status = 1;
      successCallback();
    }
  }

  bool hasVotePassed(){
     return votedCount >= userCount + 1 / 2;
  }
}