function [scoreboard]= createScoreboard(player1Name, player2Name, player1Scores, player2Scores )


%I'm assuming that player1scores and player2scores are arrays created by
%another function, but that can be changed if necessary


%initializing scoreboard
scoreboard= table;

tableSize= [2, 7];
variableTypes= ["string", "double",  "double",  "double",  "double",  "double",  "double", ];
tableLabel=["Player Name", "Round 1", "Round 2", "Round 3", "Round 4", "Round 5", "Total"];

scoreboard = table('Size',tableSize,'VariableTypes',variableTypes,'VariableNames',tableLabel);


%variables for indexing stuff :)

p1Rounds= length(player1Scores);
p2Rounds= length(player2Scores);


%input values into table 

p1Total= sum(player1Scores);
p2Total= sum(player2Scores);


scoreboard(1, 1)= {player1Name};
scoreboard(2,1 )= {player2Name};
scoreboard(1, 7)= {p1Total};
scoreboard (2, 7)= {p2Total};



tableIndex1=p1Rounds+1;
tableIndex2=p2Rounds+1;


for i= 2:tableIndex1
    
    scoreboard(1, i)= {player1Scores(i-1)};
end

for j= 2:tableIndex2
    
    
     scoreboard(2, j)= {player2Scores(j-1)};
end
end





