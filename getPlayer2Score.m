function  [data2]= getPlayer2Score(playerRoundNum, Player2Scores)

roundArray = (1:playerRoundNum)'
scoreArray = (Player2Scores)'

together = [roundArray, scoreArray];
data2 = together;



end