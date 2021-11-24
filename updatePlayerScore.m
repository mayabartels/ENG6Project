function [updateScore] = updatePlayerScore(scoreArray, currentRound, currentScore, roundScore, playerRolls)
    
    if roundScore == 0
        
        % Make it so that round scores are all subtracted off of the
        % currentScore
        firstRoundScore = currentRound - playerRolls;
        previousRounds = scoreArray((currentRound - 1):-1:firstRoundScore);
        sumRounds = sum(previousRounds);
        updateScore = currentScore - sumRounds;
        
    else
        
        % Update the current score for the player
        updateScore = currentScore + roundScore;
        
    end

end