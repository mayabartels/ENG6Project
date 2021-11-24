classdef gamePlayer
% 
    
    % Define properties for each player
    properties (GetAccess = public)
        playerName;     % Name of the player object
        playerNum;      % {1,2} since game will be played by 1 or 2 players
        playerScore;    % Keep track of the score for each player object
        playerRoundNum; % Keep track of the round number for each player
        playerTurn;     % Boolean value for if it is the player's turn
        playerWin;      % Boolean value for if the player won (1 = win, 0 = lose)
    end
    
    methods
        
        % Creating object method
        function obj = gamePlayer(playerName, playerNum, playerScore, playerRoundNum, playerTurn, playerWin)
            
            if nargin == 6
                obj.playerName = playerName;
                obj.playerNum = playerNum;
                obj.playerScore = playerScore;
                obj.playerRoundNum = playerRoundNum;
                obj.playerTurn = playerTurn;
                obj.playerWin = playerWin;
            else
                disp("Input error message");
            end
            
        end
        
    end
    
end