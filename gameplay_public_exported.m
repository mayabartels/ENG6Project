classdef gameplay_public_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        UITable                matlab.ui.control.Table
        UITable2               matlab.ui.control.Table
        RollButton_2           matlab.ui.control.Button
        RollButton             matlab.ui.control.Button
        EndTurnButton_2        matlab.ui.control.Button
        EndTurnButton_3        matlab.ui.control.Button
        Image                  matlab.ui.control.Image
        Image2                 matlab.ui.control.Image
        ScoreEditFieldLabel    matlab.ui.control.Label
        ScoreEditField         matlab.ui.control.NumericEditField
        ScoreEditField_2Label  matlab.ui.control.Label
        ScoreEditField_2       matlab.ui.control.NumericEditField
        RollAgainButton_3      matlab.ui.control.Button
        Image3                 matlab.ui.control.Image
        Image4                 matlab.ui.control.Image
        RollAgainButton_2      matlab.ui.control.Button
        EndGameButton           matlab.ui.control.Button
        SnakeEyesRolledLabel    matlab.ui.control.Label
        OneSnakeEyeRolledLabel  matlab.ui.control.Label
        XButton                matlab.ui.control.Button
        Image5                 matlab.ui.control.Image
        Player1EditFieldLabel  matlab.ui.control.Label
        Player1EditField       matlab.ui.control.EditField
        Player2EditFieldLabel  matlab.ui.control.Label
        Player2EditField       matlab.ui.control.EditField
        roundNum 
        
        
        Player1 = gamePlayer("Player 1 Name", 1, 0, 1, true, false); % Creating Player1 object
        Player2 = gamePlayer("Player 2 Name", 2, 0, 1, false, false); % Creating Player2 object
        PlayerRolls = 0;       % Used to track the number of rolls per turn for each player
        Player1Scores = [];    % Array created for player 1 scores
        Player2Scores = [];    % Array created for player 2 scores
    end


    properties (Access = private)
        DialogApp                   % Dialog box app
        CurrentSize = 35;           % Surface sample size
        CurrentColormap = 'Parula'; % Colormap
        
        myPlayerNum 
        otherPlayerNum 
        
        channelID 
        writeKey 
        readKey   
        readDelay 
        writeDelay  
        
        roll  
        myLastRoll  
        otherLastRoll
    end

    methods (Access = public)
    
        function updateplot(app, sz, c)
            % Store inputs as properties
            app.CurrentSize = sz;
            app.CurrentColormap = c;
            
            % Update plot 
            Z = peaks(sz);
            surf(app.UIAxes,Z);
            colormap(app.UIAxes,c);
            
            % Re-enable the Plot Options button
            app.OptionsButton.Enable = 'on';
        end
        
        function [] = WaitForOtherPlayer(app)
            playerWhoSentMsg = 0;
            
            while playerWhoSentMsg ~= app.otherPlayerNum
                % read a data table from the channel
                dataTable = thingSpeakRead(app.channelID, 'Fields', 1, 'ReadKey', ...
                    app.readKey, 'OutputFormat','Table');
                              
                % access the entry in the table containing the data string
                dataString = string(dataTable.dataString(1));
                
                % to help with debugging
                disp("I am player " + num2str(app.myPlayerNum) ...
                    + " and I just read this data from the ThingSpeak channel:");
                disp(dataString);
                
                % split data string into separate numbers
                dataParts = split(strip(dataString));
                
                % the first number in the string should 
                % always be the number of the player who
                % last wrote the data
                playerWhoSentMsg = str2num(dataParts(1));
                
                % delay before trying to read the online channel again
                pause(app.readDelay);              
            end
        end  
        
        function [] = ClearThinkSpeakChannel(app)
            thingSpeakWrite(app.channelID, 'Fields', 1, 'Values', "0", 'WriteKey', app.writeKey);
        end

        function [] = SendDataToOtherPlayer(app)
            pause(app.writeDelay);
            dataString = strcat(string(app.myPlayerNum), " ", ...
                string(app.myLastRoll.suit), " ", ...
                string(app.myLastRoll.num), " ");
            
            rollString = app.MakeStringFromRoll(app.roll);
            dataString = strcat(dataString, rollString);
            
            disp("I sent this data to the ThingSpeak channel: ");
            disp(dataString);
            
            thingSpeakWrite(app.channelID, 'Fields', 1, 'Values', dataString ...
                ,'WriteKey', app.writeKey); 
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, data)

            %player icons and dice animation:
            set(app.Image,'visible','on');
            set(app.Image2,'visible','on');
            set(app.Image3,'visible','off');
            set(app.Image4,'visible','off');

            %snake eyes animation:
            set(app.Image5,'visible','off');
            set(app.XButton,'visible','off');
            
            % Hide the snake eyes labels
            set(app.SnakeEyesRolledLabel, 'visible', 'off');
            set(app.OneSnakeEyeRolledLabel, 'visible', 'off');
            
            % Switch dice placement for image
            % Image visualization commands
            set(app.Image3,'visible','off');
            set(app.Image4,'visible','on');
            
            % Get player names
            %global player1Name
            %global player2Name
            %app.Player1.playerName = player1Name;
            %app.Player2.playerName = player2Name;
            
            % Set player names
            %app.Player1EditField.Value = app.Player1.playerName;
            %app.Player2EditField.Value = app.Player2.playerName;
            
            app.myPlayerNum = 1;
            app.otherPlayerNum = 2;
            app.roundNum=0

            app.channelID = 1580913;
            app.writeKey = "P8W9ZHP2WOD6RP3Y";
            app.readKey = "I8DVSH0CY0H0AV1X";

            app.readDelay = 5;
            app.writeDelay = 1;
            app.ClearThinkSpeakChannel();
            set(app.RollButton, 'Enable', 'on');
            
        

            %%% Must fix following
             % if app.snakeyes.player1 = valuechanged
             %    app.myPlayerNum = 1;
             %    app.otherPlayerNum = 2;
             % else
             %    app.myPlayerNum = 2;
             %   app.otherPlayerNum = 1;
             % end

        end
        
        % Callback function
        function OptionsButtonPushed(app, event)
            % Disable Plot Options button while dialog is open
            app.OptionsButton.Enable = 'off';
            
            % Open the options dialog and pass inputs
            app.DialogApp = DialogAppExample(app, app.CurrentSize, app.CurrentColormap);
        end

        % Close request function: UIFigure
        function MainAppCloseRequest(app, event)
            % Delete both apps
            delete(app.DialogApp)
            delete(app)
        end

        % Button pushed function: PlayagainButton
        function RollButton_2Pushed(app, event)
            
            if app.Player1.playerTurn && app.PlayerRolls == 0
                
                % Reset the snake eye labels to off when next roll happens
                set(app.SnakeEyesRolledLabel, 'visible', 'off');
                set(app.OneSnakeEyeRolledLabel, 'visible', 'off');
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore, snakeEyes, snakeEye] = scoreUpdate(rollScore);
                
                % Update the player score based on the dice roll
                scores = app.Player1Scores;
                playerRoundNum = app.Player1.playerRoundNum;
                currentScore = app.Player1.playerScore;
                
                [playerScore] = updatePlayerScore(scores, playerRoundNum, currentScore, diceScore, app.PlayerRolls);
                app.Player1.playerScore = playerScore;
                disp(app.Player1.playerScore)
                
                % Reset the player score if necessary (snake eyes rolled)
                resetScore(app.Player1, gameScore);
                
                % Display the player score and store it in the Player
                % Scores Array
                app.ScoreEditField.Value = playerScore;
                app.Player1Scores(app.Player1.playerRoundNum) = diceScore;
                
                 %format data to display in table later
                [data1]= getPlayer1Score(app.Player1.playerRoundNum, app.Player1Scores);
                
                % Increase the player round by 1
                app.Player1.playerRoundNum = app.Player1.playerRoundNum + 1;
                
                % Counts the number of rolls per round
                app.PlayerRolls = app.PlayerRolls + 1;
              
                % Update table with score data
                app.UITable.Data= data1;
                
                % Make it the other player's turn if snake eye or eyes
                % rolled
                if gameScore == 0
                    
                    % Switch the player turn
                    app.Player1.playerTurn = false;
                    app.Player2.playerTurn = true;
                    
                    
                    % Set the player rolls per round to zero again
                    app.PlayerRolls = 0;
                    
                    % Switch dice placement for image
                    % Image visualization commands
                    set(app.Image3,'visible','on');
                    set(app.Image4,'visible','off');
                    
                    % Display snake eyes or snake eye if either was rolled
                    if snakeEyes
                        
                        set(app.SnakeEyesRolledLabel, 'visible', 'on');

                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    elseif snakeEye
                        
                        set(app.OneSnakeEyeRolledLabel, 'visible', 'on');

                         %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    end
                    
                else
                end
                
            end
            
            % Audio commands
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)
            
        end
        
        % Value changed function: ScoreEditField
        function ScoreEditFieldValueChanged(app, event)
            
        end

        % Button pushed function: RollagainButton
        function RollButtonPushed(app, event)
            
            if (app.myPlayerNum == 1)
                set(app.RollButton, 'Enable', 'on');
                set(app.RollAgainButton_2, 'Enable', 'on')
                set(app.EndTurnButton_2, 'Enable', 'on')
                
            else % app.myPlayerNum == 2
                app.WaitForOtherPlayer();
                set(app.RollButton_2, 'Enable', 'on');
                set(app.RollAgainButton_3, 'Enable', 'on' );
                set(app.EndTurnButton_3, 'Enable', 'on');
            end
            
            if app.Player2.playerTurn && app.PlayerRolls == 0
                
                % Reset the snake eye labels to off when next roll happens
                set(app.SnakeEyesRolledLabel, 'visible', 'off');
                set(app.OneSnakeEyeRolledLabel, 'visible', 'off');
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore, snakeEyes, snakeEye] = scoreUpdate(rollScore);
                
                % Update the player score based on the dice roll
                scores = app.Player2Scores;
                playerRoundNum = app.Player2.playerRoundNum;
                currentScore = app.Player2.playerScore;
                
                [playerScore] = updatePlayerScore(scores, playerRoundNum, currentScore, diceScore, app.PlayerRolls);
                app.Player2.playerScore = playerScore;
                disp(app.Player2.playerScore)
                
                % Reset the player score if necessary (snake eyes rolled)
                resetScore(app.Player2, gameScore);
                
                % Display the player score and store the round score in the Player
                % Scores Array
                app.ScoreEditField_2.Value = playerScore;
                app.Player2Scores(app.Player2.playerRoundNum) = diceScore;
                
                %format data to display in table later
                [data2]= getPlayer2Score(app.Player2.playerRoundNum, app.Player2Scores);
                
                % Increase the player round by 1
                app.Player2.playerRoundNum = app.Player2.playerRoundNum + 1;
                
                % Counts the number of rolls per round
                app.PlayerRolls = app.PlayerRolls + 1;
                
                % Update table with score data
                app.UITable2.Data= data2;
                
                % Make it the other player's turn if snake eye or eyes
                % rolled
                if gameScore == 0

                    % Switch the player turn
                    app.Player1.playerTurn = true;
                    app.Player2.playerTurn = false;
                    app.roundNum= app.roundNum +1
                  
                    
                    % Set the player rolls per round to zero again
                    app.PlayerRolls = 0;
                    
                    % Switch dice placement for image
                    % Image visualization commands
                    set(app.Image3,'visible','off');
                    set(app.Image4,'visible','on');
                    
                    % Display snake eyes or snake eye if either was rolled
                    if snakeEyes
                        
                        set(app.SnakeEyesRolledLabel, 'visible', 'on');

                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    elseif snakeEye
                        set(app.OneSnakeEyeRolledLabel, 'visible', 'on');

                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    end

                else
                end
                
             
                
            end
            
            % Audio commands
            [y,Fs]=audioread("MANYDICE.wav");
            sound(y,Fs)
            
         if app.roundNum ==5
                         % Determine winner based on scores
                        if app.Player1.playerScore > app.Player2.playerScore
                            app.Player1.playerWin = true;
                            app.Player2.playerWin = false;
                        elseif app.Player2.playerScore > app.Player1.playerScore
                            app.Player1.playerWin = false;
                            app.Player2.playerWin = true;
                        elseif app.Player1.playerScore == app.Player2.playerScore
                            app.Player1.playerWin = false;
                            app.Player2.playerWin = false;
                        end

                        disp(app.Player1.playerName)
                        disp(app.Player2.playerName)

                        % Determine winning player name
                        global endingWinner
                        if app.Player1.playerWin
                            endingWinner = app.Player1.playerName;
                        elseif app.Player2.playerWin
                            endingWinner = app.Player2.playerName;
                        elseif ~app.Player1.playerWin && ~ app.Player2.playerWin
                            endingWinner = "Tie";
                        end

                        % Open endgame screen and close gameplay
                        endgamescreen_exported
                        close(app.UIFigure)

                        % Audio commands
                        [y,Fs] = audioread("winnerSound.mp3");
                        sound(y,Fs)
                    end
        
        
        end
        
        % Value changed function: ScoreEditField_2
        function ScoreEditField_2ValueChanged(app, event)
         
        end

        % Button pushed function: EndgameButton
        function EndTurnButton_3Pushed(app, event)
            
            if app.Player1.playerTurn
                
                % Switch the player turn when pushed
                app.Player1.playerTurn = ~app.Player1.playerTurn;
                app.Player2.playerTurn = ~app.Player2.playerTurn;
                
                % Switch dice placement for image
                % Image visualization commands
                set(app.Image3,'visible','on');
                set(app.Image4,'visible','off');
                
            else
            end
            
            % Set the player rolls per round to zero again
            app.PlayerRolls = 0;

            % Audio commands
            [y,Fs] = audioread("endGame.wav");
            sound(y,Fs)
            
        end

        % Button pushed function: EndGameButton
        function EndTurnButton_2Pushed(app, event)
            
            if app.Player2.playerTurn
                
                % Switch the player turn when pushed
                app.Player1.playerTurn = ~app.Player1.playerTurn;
                app.Player2.playerTurn = ~app.Player2.playerTurn;
                app.roundNum= app.roundNum +1
                 
                    
                
                % Switch dice placement for image
                % Image visualization commands
                set(app.Image3,'visible','off');
                set(app.Image4,'visible','on');
                
            else
            end
            
            % Set the player rolls per round to zero again
            app.PlayerRolls = 0;

            % Audio commands
            [y,Fs] = audioread("endGame.wav");
            sound(y,Fs)
            
             if app.roundNum ==5
                         % Determine winner based on scores
                        if app.Player1.playerScore > app.Player2.playerScore
                            app.Player1.playerWin = true;
                            app.Player2.playerWin = false;
                        elseif app.Player2.playerScore > app.Player1.playerScore
                            app.Player1.playerWin = false;
                            app.Player2.playerWin = true;
                        elseif app.Player1.playerScore == app.Player2.playerScore
                            app.Player1.playerWin = false;
                            app.Player2.playerWin = false;
                        end

                        disp(app.Player1.playerName)
                        disp(app.Player2.playerName)

                        % Determine winning player name
                        global endingWinner
                        if app.Player1.playerWin
                            endingWinner = app.Player1.playerName;
                        elseif app.Player2.playerWin
                            endingWinner = app.Player2.playerName;
                        elseif ~app.Player1.playerWin && ~ app.Player2.playerWin
                            endingWinner = "Tie";
                        end

                        % Open endgame screen and close gameplay
                        endgamescreen_exported
                        close(app.UIFigure)

                        % Audio commands
                        [y,Fs] = audioread("winnerSound.mp3");
                        sound(y,Fs)
                    end
            
        end
        
        % Button pushed function: RollAgainButton_3
        function RollAgainButton_3Pushed(app, event)
            
            if app.Player1.playerTurn
                
                % Reset the snake eye labels to off when next roll happens
                set(app.SnakeEyesRolledLabel, 'visible', 'off');
                set(app.OneSnakeEyeRolledLabel, 'visible', 'off');
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore, snakeEyes, snakeEye] = scoreUpdate(rollScore);
                
                % Update the player score based on the dice roll
                scores = app.Player1Scores;
                playerRoundNum = app.Player1.playerRoundNum;
                currentScore = app.Player1.playerScore;
                
                [playerScore] = updatePlayerScore(scores, playerRoundNum, currentScore, diceScore, app.PlayerRolls);
                app.Player1.playerScore = playerScore;
                disp(app.Player1.playerScore)
                
                % Reset the player score if necessary (snake eyes rolled)
                resetScore(app.Player1, gameScore);
                
                % Display the player score and store it in the Player
                % Scores Array
                app.ScoreEditField.Value = playerScore;
                app.Player1Scores(app.Player1.playerRoundNum) = diceScore;
                
                %format data to display in table later
                [data1]= getPlayer1Score(app.Player1.playerRoundNum, app.Player1Scores);
               
                % Update table with score data
                app.UITable.Data = data1;
                
                % Increase the player round by 1
                app.Player1.playerRoundNum = app.Player1.playerRoundNum + 1;
                
                % Counts the number of rolls per round
                app.PlayerRolls = app.PlayerRolls + 1;
                
                % Make it the other player's turn if snake eye or eyes
                % rolled
                if gameScore == 0
                    
                    % Switch the player turn
                    app.Player1.playerTurn = false;
                    app.Player2.playerTurn = true;
                    
                    % Set the player rolls per round to zero again
                    app.PlayerRolls = 0;
                    
                    % Switch dice placement for image
                    % Image visualization commands
                    set(app.Image3,'visible','on');
                    set(app.Image4,'visible','off');

                    % Display snake eyes or snake eye if either was rolled
                    if snakeEyes
                        
                        set(app.SnakeEyesRolledLabel, 'visible', 'on');

                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    elseif snakeEye
                        
                        set(app.OneSnakeEyeRolledLabel, 'visible', 'on');
                        
                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    end

                else
                end
                
            end
            
            % Audio commands
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)
           
        end

        % Button pushed function: RollAgainButton_2
        function RollAgainButton_2Pushed(app, event)
            
            if app.Player2.playerTurn
                
                % Reset the snake eye labels to off when next roll happens
                set(app.SnakeEyesRolledLabel, 'visible', 'off');
                set(app.OneSnakeEyeRolledLabel, 'visible', 'off');
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore, snakeEyes, snakeEye] = scoreUpdate(rollScore);
                
                % Update the player score based on the dice roll
                scores = app.Player2Scores;
                playerRoundNum = app.Player2.playerRoundNum;
                currentScore = app.Player2.playerScore;
                
                [playerScore] = updatePlayerScore(scores, playerRoundNum, currentScore, diceScore, app.PlayerRolls);
                app.Player2.playerScore = playerScore;
                disp(app.Player2.playerScore)
                
                % Reset the player score if necessary (snake eyes rolled)
                resetScore(app.Player2, gameScore);
                
                % Display the player score and store the round score in the Player
                % Scores Array
                app.ScoreEditField_2.Value = playerScore;
                app.Player2Scores(app.Player2.playerRoundNum) = diceScore;
                
                %format data to display in table later
                [data2]= getPlayer2Score(app.Player2.playerRoundNum, app.Player2Scores);
                
                % Update table with score data
                app.UITable2.Data = data2;
                
                % Increase the player round by 1
                app.Player2.playerRoundNum = app.Player2.playerRoundNum + 1;
                
                % Counts the number of rolls per round
                app.PlayerRolls = app.PlayerRolls + 1;
                
                % Make it the other player's turn if snake eye or eyes
                % rolled
                if gameScore == 0
                    
                    % Switch the player turn
                    app.Player1.playerTurn = true;
                    app.Player2.playerTurn = false;
                    app.roundNum= app.roundNum+1
                    
                  
                    
                    % Set the player rolls per round to zero again
                    app.PlayerRolls = 0;
                    
                    % Switch dice placement for image
                    % Image visualization commands
                    set(app.Image3,'visible','off');
                    set(app.Image4,'visible','on');
                    
                    % Display snake eyes or snake eye if either was rolled
                    if snakeEyes
                        
                        set(app.SnakeEyesRolledLabel, 'visible', 'on');

                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)

                    elseif snakeEye
                        
                        set(app.OneSnakeEyeRolledLabel, 'visible', 'on');

                        %Snake Eyes Image and close Button
                        set(app.Image5,'visible','on');
                        set(app.XButton,'visible','on');

                        % Audio commands
                        [y,Fs] = audioread("snakeHiss.wav");
                        sound(y,Fs)
                        

                    end
                   
                    
                else
                end
                
            end
            
            % Audio commands
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)
            
              if app.roundNum ==5
                         % Determine winner based on scores
                        if app.Player1.playerScore > app.Player2.playerScore
                            app.Player1.playerWin = true;
                            app.Player2.playerWin = false;
                        elseif app.Player2.playerScore > app.Player1.playerScore
                            app.Player1.playerWin = false;
                            app.Player2.playerWin = true;
                        elseif app.Player1.playerScore == app.Player2.playerScore
                            app.Player1.playerWin = false;
                            app.Player2.playerWin = false;
                        end

                        disp(app.Player1.playerName)
                        disp(app.Player2.playerName)

                        % Determine winning player name
                        global endingWinner
                        if app.Player1.playerWin
                            endingWinner = app.Player1.playerName;
                        elseif app.Player2.playerWin
                            endingWinner = app.Player2.playerName;
                        elseif ~app.Player1.playerWin && ~ app.Player2.playerWin
                            endingWinner = "Tie";
                        end

                        % Open endgame screen and close gameplay
                        endgamescreen_exported
                        close(app.UIFigure)

                        % Audio commands
                        [y,Fs] = audioread("winnerSound.mp3");
                        sound(y,Fs)
                    end
            
        end
        
        % Button pushed function: EndGameButton
        function EndGameButtonPushed(app, event)
            
            % Determine winner based on scores
            if app.Player1.playerScore > app.Player2.playerScore
                app.Player1.playerWin = true;
                app.Player2.playerWin = false;
            elseif app.Player2.playerScore > app.Player1.playerScore
                app.Player1.playerWin = false;
                app.Player2.playerWin = true;
            elseif app.Player1.playerScore == app.Player2.playerScore
                app.Player1.playerWin = false;
                app.Player2.playerWin = false;
            end
            
            disp(app.Player1.playerName)
            disp(app.Player2.playerName)
            
            % Determine winning player name
            global endingWinner
            if app.Player1.playerWin
                endingWinner = app.Player1.playerName;
            elseif app.Player2.playerWin
                endingWinner = app.Player2.playerName;
            elseif ~app.Player1.playerWin && ~ app.Player2.playerWin
                endingWinner = "Tie";
            end
            
            % Open endgame screen and close gameplay
            endgamescreen_exported
            close(app.UIFigure)
            
            % Audio commands
            [y,Fs] = audioread("winnerSound.mp3");
            sound(y,Fs)
            
        end
        
        % Value changed function: Player1EditField
        function Player1EditFieldValueChanged(app, event)
            app.Player1.playerName = app.Player1EditField.Value;
            disp(app.Player1.playerName)
        end

        % Value changed function: Player2EditField
        function Player2EditFieldValueChanged(app, event)
            app.Player2.playerName = app.Player2EditField.Value;
            disp(app.Player2.playerName)
        end

         % Button pushed function: XButton
        function XButtonPushed(app, event)
            %Snake Eyes Image and close Button-Turn off
            set(app.Image5,'visible','off');
            set(app.XButton,'visible','off');
        end
        
    end


    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.4667 0.6745 0.1882];
            app.UIFigure.Position = [100 100 539 377];
            app.UIFigure.Name = 'Display Plot';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @MainAppCloseRequest, true);

              % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Round'; 'Score'};
            app.UITable.RowName = {};
            app.UITable.Position = [372 202 161 167];

            % Create UITable2
            app.UITable2 = uitable(app.UIFigure);
            app.UITable2.ColumnName = {'Round'; 'Score'};
            app.UITable2.RowName = {};
            app.UITable2.Position = [373 15 161 177];

            % Create RollButton_2
            app.RollButton_2 = uibutton(app.UIFigure, 'push');
            app.RollButton_2.ButtonPushedFcn = createCallbackFcn(app, @RollButton_2Pushed, true);
            app.RollButton_2.Position = [269 307 100 22];
            app.RollButton_2.Text = 'Roll';

            % Create RollButton
            app.RollButton = uibutton(app.UIFigure, 'push');
            app.RollButton.ButtonPushedFcn = createCallbackFcn(app, @RollButtonPushed, true);
            app.RollButton.Position = [269 163 100 22];
            app.RollButton.Text = 'Roll';

            % Create EndTurnButton_2
            app.EndTurnButton_2 = uibutton(app.UIFigure, 'push');
            app.EndTurnButton_2.ButtonPushedFcn = createCallbackFcn(app, @EndTurnButton_2Pushed, true);
            app.EndTurnButton_2.Position = [270 101 100 22];
            app.EndTurnButton_2.Text = 'End Turn';

            % Create EndTurnButton_3
            app.EndTurnButton_3 = uibutton(app.UIFigure, 'push');
            app.EndTurnButton_3.ButtonPushedFcn = createCallbackFcn(app, @EndTurnButton_3Pushed, true);
            app.EndTurnButton_3.Position = [272 242 100 22];
            app.EndTurnButton_3.Text = 'End Turn';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [40 223 71 97];
            app.Image.ImageSource = 'SnakeIcon2.jpg';

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [18 42 108 122];
            app.Image2.ImageSource = 'SnakeIcon.jpg';

            % Create ScoreEditFieldLabel
            app.ScoreEditFieldLabel = uilabel(app.UIFigure);
            app.ScoreEditFieldLabel.HorizontalAlignment = 'right';
            app.ScoreEditFieldLabel.Position = [153 286 40 22];
            app.ScoreEditFieldLabel.Text = 'Score:';

            % Create ScoreEditField
            app.ScoreEditField = uieditfield(app.UIFigure, 'numeric');
            app.ScoreEditField.ValueChangedFcn = createCallbackFcn(app, @ScoreEditFieldValueChanged, true);
            app.ScoreEditField.Position = [208 286 35 22];

            % Create ScoreEditField_2Label
            app.ScoreEditField_2Label = uilabel(app.UIFigure);
            app.ScoreEditField_2Label.HorizontalAlignment = 'right';
            app.ScoreEditField_2Label.Position = [154 109 40 22];
            app.ScoreEditField_2Label.Text = 'Score:';

            % Create ScoreEditField_2
            app.ScoreEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.ScoreEditField_2.ValueChangedFcn = createCallbackFcn(app, @ScoreEditField_2ValueChanged, true);
            app.ScoreEditField_2.Position = [209 109 35 22];
            
            % Create Player1EditFieldLabel
            app.Player1EditFieldLabel = uilabel(app.UIFigure);
            app.Player1EditFieldLabel.HorizontalAlignment = 'right';
            app.Player1EditFieldLabel.Position = [10 197 49 22];
            app.Player1EditFieldLabel.Text = 'Player 1';

            % Create Player1EditField
            app.Player1EditField = uieditfield(app.UIFigure, 'text');
            app.Player1EditField.ValueChangedFcn = createCallbackFcn(app, @Player1EditFieldValueChanged, true);
            app.Player1EditField.Position = [74 197 100 22];

            % Create Player2EditFieldLabel
            app.Player2EditFieldLabel = uilabel(app.UIFigure);
            app.Player2EditFieldLabel.HorizontalAlignment = 'right';
            app.Player2EditFieldLabel.Position = [10 15 49 22];
            app.Player2EditFieldLabel.Text = 'Player 2';

            % Create Player2EditField
            app.Player2EditField = uieditfield(app.UIFigure, 'text');
            app.Player2EditField.ValueChangedFcn = createCallbackFcn(app, @Player2EditFieldValueChanged, true);
            app.Player2EditField.Position = [74 15 100 22];

            % Create RollAgainButton_3
            app.RollAgainButton_3 = uibutton(app.UIFigure, 'push');
            app.RollAgainButton_3.ButtonPushedFcn = createCallbackFcn(app, @RollAgainButton_3Pushed, true);
            app.RollAgainButton_3.Position = [271 274 100 22];
            app.RollAgainButton_3.Text = 'Roll Again';

            % Create Image3
            app.Image3 = uiimage(app.UIFigure);
            app.Image3.Position = [96 77 53 47];
            app.Image3.ImageSource = 'dice_gif.gif';

            % Create Image4
            app.Image4 = uiimage(app.UIFigure);
            app.Image4.Position = [97 274 52 43];
            app.Image4.ImageSource = 'dice_gif.gif';

            % Create RollAgainButton_2
            app.RollAgainButton_2 = uibutton(app.UIFigure, 'push');
            app.RollAgainButton_2.ButtonPushedFcn = createCallbackFcn(app, @RollAgainButton_2Pushed, true);
            app.RollAgainButton_2.Position = [270 130 100 22];
            app.RollAgainButton_2.Text = 'Roll Again';
            
            % Create EndGameButton
            app.EndGameButton = uibutton(app.UIFigure, 'push');
            app.EndGameButton.ButtonPushedFcn = createCallbackFcn(app, @EndGameButtonPushed, true);
            app.EndGameButton.BackgroundColor = [0.9686 0.6902 0.6902];
            app.EndGameButton.Position = [177 27 188 32];
            app.EndGameButton.Text = 'End Game';

            % Create SnakeEyesRolledLabel
            app.SnakeEyesRolledLabel = uilabel(app.UIFigure);
            app.SnakeEyesRolledLabel.HorizontalAlignment = 'center';
            app.SnakeEyesRolledLabel.FontColor = [1 0 0];
            app.SnakeEyesRolledLabel.Position = [97 336 152 30];
            app.SnakeEyesRolledLabel.Text = 'Snake Eyes Rolled!';

            % Create OneSnakeEyeRolledLabel
            app.OneSnakeEyeRolledLabel = uilabel(app.UIFigure);
            app.OneSnakeEyeRolledLabel.HorizontalAlignment = 'center';
            app.OneSnakeEyeRolledLabel.FontColor = [1 0 0];
            app.OneSnakeEyeRolledLabel.Position = [97 336 152 30];
            app.OneSnakeEyeRolledLabel.Text = 'One Snake Eye Rolled!';

             % Create Image5
            app.Image5 = uiimage(app.UIFigure);
            app.Image5.Position = [100 139 222 148];
            app.Image5.ImageSource = 'SnakeEyesGif.gif';

            % Create XButton
            app.XButton = uibutton(app.UIFigure, 'push');
            app.XButton.ButtonPushedFcn = createCallbackFcn(app, @XButtonPushed, true);
            app.XButton.BackgroundColor = [0.149 0.149 0.149];
            app.XButton.FontColor = [1 1 1];
            app.XButton.Position = [284 250 30 22];
            app.XButton.Text = 'X';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
            
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = gameplay_public_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)
            
            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end