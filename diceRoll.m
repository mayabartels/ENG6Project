function [rollScore, outGameScore, outRoundScore, diceOne, diceTwo]= diceRoll(roll)


%I = imread('dice1.png');  
%j=imshow(I)
persistent gameScore %will track total score over game
persistent roundScore %will track total score over round

if isempty(gameScore) & isempty(roundScore) & roll==true
    gameScore= 0;
    roundScore=0;
    disp ("roll again to start game")
else
    

if (roll==true) %rolling dice
    
   rollScore= randi(6,1, 2)
   diceOne= rollScore(1);
   diceTwo= rollScore(2);
    diceOneZero= (diceOne ~= 1); %returns zero if dice value is zero
  diceTwoZero= (diceTwo ~= 1);

  if xor(diceOneZero, diceTwoZero) %if only one dice is 1
        
        rollScore= 0;
        roundScore= 0;
        
        outRoundScore= roundScore;
        outGameScore= gameScore;
        
    disp ("End of Round!")
    X= ['Round Score:', num2str(outRoundScore)];
    Y= ['Game Score:', num2str(outGameScore)];
     
    disp(X)
    disp(Y)
    elseif diceOne==1 & diceTwo==1 %if both dice are 1
       
        disp ("Snake Eyes!")
        rollScore= 0; 
        roundScore= 0;
        gameScore= 0;
        
         outRoundScore= roundScore;
         outGameScore= gameScore;
        
        disp ("End of Round!")
         X= ['Round Score:', num2str(outRoundScore)];
         Y= ['Game Score:', num2str(outGameScore)];
     disp (X)
     disp(Y)
        
    else % if neither dice is one
         rollScore= diceOne + diceTwo;
         roundScore= roundScore +rollScore;
         gameScore= gameScore +rollScore;
         
         outRoundScore= roundScore;
         outGameScore= gameScore;
         
         disp ("Roll Again?")
         X= ['Round Score:', num2str(outRoundScore)];
         Y= ['Game Score:', num2str(outGameScore)];
         disp(X)
         disp(Y)
  end
  
    
  
else
    
    disp ("input 1 or true to roll dice")
    %later, we can use this to start the next player's turn
end

 
    
end
end
