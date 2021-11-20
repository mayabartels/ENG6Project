function [rollScore]= diceRoll(roll)

    
if (roll==true) %rolling dice
    
   rollScore= randi(6,1, 2)
 
else
    
    disp ("input 1 or true to roll dice")
    %later, we can use this to start the next player's turn
end

 
    

end
