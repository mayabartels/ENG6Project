classdef gamePlayer
% 
    
    % Define properties for each player
    properties (GetAccess = public)
        playerName;     % Name of the player object
        playerNum;      % {1,2} since game will be played by 1 or 2 players
        playerScore;    % Keep track of the score for each player object
        dice1Roll;      % The value for the first roll of the dice per turn
        dice2Roll;      % The value for the second roll of the dice per turn
    end
    
    methods
        
        % Creating object method
        function obj = gamePlayer()
            
            % Needs to be changed based on parameters put in gamePlayer
            % function
            
        end
        
        % Determine the player score based on the dice roll
        function [score] = scorePlayer(obj, roll1, roll2)
            
            % Total score for turn
            turnScore = roll1 + roll2;
            
            % Add the turn score to the player score
            score = obj.playerScore + turnScore;
            
        end
        
        % Reset score if the player rolls snake eyes
        function [scoreReset] = resetScore(roll1, roll2)
            
            % Check if the rolls both equal 1 and set the score to 0
            if (roll1 == 1 && roll2 == 1)
                scoreReset = 0;
            else
            end
            
        end
        
    end
    
end