classdef gamePlayer
% 
    
    % Define properties for each player
    properties (GetAccess = public)
        playerName;     % Name of the player object
        playerNum;      % {1,2} since game will be played by 1 or 2 players
        playerScore;    % Keep track of the score for each player object
        playerTurn;     % Boolean value for if it is the player's turn
        playerWin;      % Boolean value for if the player won (1 = win, 0 = lose)
    end
    
    methods
        
        % Creating object method
        function obj = gamePlayer()
            
            % Needs to be changed based on parameters put in gamePlayer
            % function
            
        end
        
    end
    
end