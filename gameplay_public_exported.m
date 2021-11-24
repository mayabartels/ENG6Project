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
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, data)
        set(app.Image,'visible','on');
        set(app.Image2,'visible','on');
        set(app.Image3,'visible','off');
        set(app.Image4,'visible','off');
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
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore] = scoreUpdate(rollScore);
                
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
                    
                else
                end
                
            end
            
            % Audio commands
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)

            % Image visibility commands
            set(app.Image4,'visible','on');
            set(app.Image3,'visible','off');
            
        end
        
        % Value changed function: ScoreEditField
        function ScoreEditFieldValueChanged(app, event)
            
        end

        % Button pushed function: RollagainButton
        function RollButtonPushed(app, event)
            
            if app.Player2.playerTurn && app.PlayerRolls == 0
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore] = scoreUpdate(rollScore);
                
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
                    
                    % Set the player rolls per round to zero again
                    app.PlayerRolls = 0;
                    
                else
                end
                
            end
            
            % Audio commands
            [y,Fs]=audioread("MANYDICE.wav");
            sound(y,Fs)
                
            % Image visibility commands
            set(app.Image3,'visible','on');
            set(app.Image4,'visible','off');
            
        end
        
        % Value changed function: ScoreEditField_2
        function ScoreEditField_2ValueChanged(app, event)
         
        end

        % Button pushed function: EndgameButton
        function EndTurnButton_3Pushed(app, event)
        
            %endgamescreen
            
            if app.Player1.playerTurn
                % Switch the player turn when pushed
                app.Player1.playerTurn = ~app.Player1.playerTurn;
                app.Player2.playerTurn = ~app.Player2.playerTurn;
            else
            end
            
            % Set the player rolls per round to zero again
            app.PlayerRolls = 0;
            
            % Endgame screen code
            %endgamescreen_exported

            % Audio commands
            [y,Fs] = audioread("endGame.wav");
            sound(y,Fs)
            
        end

        % Button pushed function: EndGameButton
        function EndTurnButton_2Pushed(app, event)

            %endgamescreen
            
            if app.Player2.playerTurn
                % Switch the player turn when pushed
                app.Player1.playerTurn = ~app.Player1.playerTurn;
                app.Player2.playerTurn = ~app.Player2.playerTurn;
            else
            end
            
            % Set the player rolls per round to zero again
            app.PlayerRolls = 0;
            
            % Endgame screen code
            %endgamescreen_exported

            % Audio commands
            [y,Fs] = audioread("endGame.wav");
            sound(y,Fs)
            
        end
        
        % Button pushed function: RollAgainButton_3
        function RollAgainButton_3Pushed(app, event)
            
            if app.Player1.playerTurn
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore] = scoreUpdate(rollScore);
                
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
                    
                else
                end
                
            end
            
            % Audio commands
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)
           
            % Image visualization commands
            set(app.Image4,'visible','on');
            set(app.Image3,'visible','off');
           
        end

        % Button pushed function: RollAgainButton_2
        function RollAgainButton_2Pushed(app, event)
            
            if app.Player2.playerTurn
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore] = scoreUpdate(rollScore);
                
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
                    
                    % Set the player rolls per round to zero again
                    app.PlayerRolls = 0;
                    
                else
                end
                
            end
            
            % Audio commands
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)

            % Image visualization commands
            set(app.Image3,'visible','on');
            set(app.Image4,'visible','off');
            
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
            app.UITable.Position = [388 207 137 157];

            % Create UITable2
            app.UITable2 = uitable(app.UIFigure);
            app.UITable2.ColumnName = {'Round'; 'Score'};
            app.UITable2.RowName = {};
            app.UITable2.Position = [388 27 137 171];

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