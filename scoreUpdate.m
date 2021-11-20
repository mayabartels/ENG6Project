function [updateScore] = scoreUpdate(currentScore, roundScore)
    
    % Take previous score and add the new score (only if score not reset)
    updateScore = currentScore + roundScore;

end