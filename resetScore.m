function [] = resetScore(object, roundScore)

    % Change the player score to 0 if the round score ended up being 0 for
    % the player's turn
    if roundScore == 0
        object.playerScore = 0;
    else
    end

end