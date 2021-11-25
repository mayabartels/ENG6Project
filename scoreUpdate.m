function [diceRollScore, gameScore, snakeEyes, snakeEye]= scoreUpdate(rollScore)

    diceOne = rollScore(1)
    diceTwo = rollScore(2)
    
    diceOneOne = (diceOne ~= 1); %returns zero if dice value is 1
    diceTwoOne = (diceTwo ~= 1);

    if xor(diceOneOne, diceTwoOne) %if only one dice is 1
        
        diceRollScore = 0
        gameScore = 0
        
        % Set Snake Eyes and Snake Eye to the correct boolean value
        snakeEyes = false
        snakeEye = true
  
    elseif diceOne==1 && diceTwo==1 %if both dice are 1
        
        diceRollScore= 0
        gameScore= 0
        
        % Set Snake Eyes and Snake Eye to the correct boolean value
        snakeEyes = true
        snakeEye = false

    else % if neither dice is one
        
        diceRollScore= diceOne + diceTwo;
        gameScore= 1;
        
        % Set Snake Eyes and Snake Eye to the correct boolean value
        snakeEyes = false;
        snakeEye = false;
        
    end
    
end