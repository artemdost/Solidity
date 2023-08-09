// SPDX-License-Identifier: BSD-2-Clause
pragma solidity ^0.8.0;

contract test {

  event GameCreated(address creator, uint gameNumber, uint bet);
  event GameStarted(address[] players, uint gameNumber);
  event GameComplete(address winner, uint gameNumber);

  struct Game{
    address[] players;
    uint[] moves;
    uint bet;
  }

  Game[] public games;

  // mapping (uint => Game) public games;

  function createGame(address payable participant) public payable {
    require(msg.value > 0);
    Game memory game;
    game.players = new address[](2);
    game.players[0] = msg.sender;
    game.players[1] = participant;
    game.bet = msg.value;
    games.push(game);
    emit GameCreated(msg.sender, games.length, msg.value);
  }

  function joinGame(uint gameNumber) public payable {
    if ((msg.value == games[gameNumber].bet) && (msg.sender == games[gameNumber].players[1])){
      emit GameStarted(games[gameNumber].players, gameNumber);
    }
    if (msg.value > games[gameNumber].bet){
      payable(msg.sender).transfer(msg.value-games[gameNumber].bet);
    }else{
      require(msg.value == games[gameNumber].bet);
    }

  }

  function checkStatus(uint gameNumber) public view returns(uint[] memory){
    return games[gameNumber].moves;
  } 

//  1, 2 или 3, что соответствует «камню», «бумаге», «ножницам» 
  function makeMove(uint gameNumber, uint moveNumber) public payable{ 
    games[gameNumber].moves.push(moveNumber);
    if (games[gameNumber].moves.length == 2){
      if (games[gameNumber].moves[0] == games[gameNumber].moves[1]){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet);
        payable(games[gameNumber].players[1]).transfer(games[gameNumber].bet);
        emit GameComplete(address(0), gameNumber);
      }
      if (games[gameNumber].moves[0] == 2 && games[gameNumber].moves[1] == 1){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet*2);
        emit GameComplete(address(0), gameNumber);
      }
      if (games[gameNumber].moves[0] == 3 && games[gameNumber].moves[1] == 2){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet*2);
        emit GameComplete(address(0), gameNumber);
      }
      if (games[gameNumber].moves[0] == 1 && games[gameNumber].moves[1] == 3){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet*2);
        emit GameComplete(address(0), gameNumber);
      }
      /////////////
      if (games[gameNumber].moves[1] == 2 && games[gameNumber].moves[0] == 1){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet*2);
        emit GameComplete(address(1), gameNumber);
      }
      if (games[gameNumber].moves[1] == 3 && games[gameNumber].moves[0] == 2){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet*2);
        emit GameComplete(address(1), gameNumber);
      }
      if (games[gameNumber].moves[1] == 1 && games[gameNumber].moves[0] == 3){
        payable(games[gameNumber].players[0]).transfer(games[gameNumber].bet*2);
        emit GameComplete(address(1), gameNumber);
      }
    }
  }
}
