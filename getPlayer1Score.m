function  [data1]= getPlayer1Score(playerRoundNum, Player1Scores)

roundArray = (1:playerRoundNum)'

scoreArray = (Player1Scores)'

together = [(roundArray), (scoreArray)];
data1 = num2cell(together);



end

