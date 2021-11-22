function [diceRollScore, gameScore]= scoreUpdate(rollScore)

    diceOne = rollScore(1);
    diceTwo = rollScore(2);


   
    diceOneOne= (diceOne ~= 1); %returns zero if dice value is 1
    diceTwoOne= (diceTwo ~= 1);

  if xor(diceOneOne, diceTwoOne) %if only one dice is 1

        diceRollScore= 0
       
        gameScore= 1

    
  
    elseif diceOne==1 & diceTwo==1 %if both dice are 1

      
        diceRollScore= 0 
      
        gameScore= 0

      
       
    else % if neither dice is one
         diceRollScore= diceOne + diceTwo;
       
  
         gameScore= 1;

      
  end




end