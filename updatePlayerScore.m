function [updateScore] = updatePlayerScore(currentRound, currentScore, roundScore, playerRolls)
    
    if roundScore == 0
        
        updateScore = currentRound;
        y = playerRolls;
        % Make it so that round scores are all subtracted off of the
        % currentScore
        %previousRounds = scoreboard(currentRound:-1:playerRolls);
        %sumRounds = sum(previousRounds);
        %updateScore = currentScore - sumRounds;
        
    else
        
        % Update the current score for the player
        updateScore = currentScore + roundScore;
        
    end

end