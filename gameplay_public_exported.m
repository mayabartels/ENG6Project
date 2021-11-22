classdef gameplay_public_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        ScoreEditField_2       matlab.ui.control.NumericEditField
        ScoreEditField_2Label  matlab.ui.control.Label
        ScoreEditField         matlab.ui.control.NumericEditField
        ScoreEditFieldLabel    matlab.ui.control.Label
        Image2                 matlab.ui.control.Image
        Image                  matlab.ui.control.Image
        EndgameButton          matlab.ui.control.Button
        EndGameButton          matlab.ui.control.Button
        RollagainButton        matlab.ui.control.Button
        PlayagainButton        matlab.ui.control.Button
        Player2Label           matlab.ui.control.Label
        Player1Label           matlab.ui.control.Label
        UITable2               matlab.ui.control.Table
        UITable                matlab.ui.control.Table
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
        function startupFcn(app)
            player1 = gamePlayer("Player 1 Name", 1, 0, 0, 0, 0);
            player2 = gamePlayer("Player 2 Name", 2, 0, 0, 0, 0);
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
        function PlayagainButtonPushed(app, event)
            %gameScore = randi(1,1, 12)
            %gameScore = rand(gameScore)
            
            while player1.playerTurn == 1
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore] = scoreUpdate(rollScore);
                
                % Update the player score based on the dice roll
                [playerScore] = updatePlayerScore(player1, diceScore);
                
                % Reset the player score if necessary (snake eyes rolled)
                resetScore(gameScore);
                
                % Display the player score
                app.ScoreEditField.Value = playerScore;
                
                % Make it the other player's turn if snake eye or eyes
                % rolled
                if gameScore == 0
                    
                    player1.playerTurn = 0;
                    player2.playerTurn = 1;
                    
                else
                end
                
            end
            
            %display(gameScore);
            %app.ScoreEditField.Value = gameScore
            
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)
        end

        % Value changed function: ScoreEditField
        function ScoreEditFieldValueChanged(app, event)
            
        end

        % Button pushed function: RollagainButton
        function RollagainButtonPushed(app, event)
            %gameScore = randi(1,1, 12)
            %gameScore = rand(gameScore)
            
            while player2.playerTurn == 1
                
                % Roll the dice
                [rollScore] = diceRoll(1);
                
                % Calculate the score for the round
                [diceScore, gameScore] = scoreUpdate(rollScore);
                
                % Update the player score based on the dice roll
                [playerScore] = updatePlayerScore(player2, diceScore);
                
                % Reset the player score if necessary (snake eyes rolled)
                resetScore(gameScore);
                
                % Display the player score
                app.ScoreEditField.Value = playerScore;
                
                % Make it the other player's turn if snake eye or eyes
                % rolled
                if gameScore == 0
                    
                    player1.playerTurn = 1;
                    player2.playerTurn = 0;
                    
                else
                end
                
            end
            
            %display(gameScore);
            %app.ScoreEditField_2.Value = gameScore
            
            [y,Fs] = audioread("MANYDICE.wav");
            sound(y,Fs)
        end

        % Value changed function: ScoreEditField_2
        function ScoreEditField_2ValueChanged(app, event)
         
        end

        % Button pushed function: EndgameButton
        function EndgameButtonPushed(app, event)
            endgamescreen
         [  y,Fs] = audioread("endGame.wav");
            sound(y,Fs)   
        end

        % Button pushed function: EndGameButton
        function EndGameButtonPushed(app, event)
            endgamescreen
            [y,Fs] = audioread("endGame.wav");
            sound(y,Fs)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.7098 0.8 0.7373];
            app.UIFigure.Position = [100 100 537 370];
            app.UIFigure.Name = 'Display Plot';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @MainAppCloseRequest, true);

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Round'; 'Score'};
            app.UITable.RowName = {};
            app.UITable.Position = [388 200 137 157];

            % Create UITable2
            app.UITable2 = uitable(app.UIFigure);
            app.UITable2.ColumnName = {'Round'; 'Score'};
            app.UITable2.RowName = {};
            app.UITable2.Position = [388 20 137 171];

            % Create Player1Label
            app.Player1Label = uilabel(app.UIFigure);
            app.Player1Label.Position = [24 321 49 22];
            app.Player1Label.Text = 'Player 1';

            % Create Player2Label
            app.Player2Label = uilabel(app.UIFigure);
            app.Player2Label.Position = [24 135 49 22];
            app.Player2Label.Text = 'Player 2';

            % Create PlayagainButton
            app.PlayagainButton = uibutton(app.UIFigure, 'push');
            app.PlayagainButton.ButtonPushedFcn = createCallbackFcn(app, @PlayagainButtonPushed, true);
            app.PlayagainButton.Position = [269 300 100 22];
            app.PlayagainButton.Text = 'Play again';

            % Create RollagainButton
            app.RollagainButton = uibutton(app.UIFigure, 'push');
            app.RollagainButton.ButtonPushedFcn = createCallbackFcn(app, @RollagainButtonPushed, true);
            app.RollagainButton.Position = [269 156 100 22];
            app.RollagainButton.Text = 'Roll again';

            % Create EndGameButton
            app.EndGameButton = uibutton(app.UIFigure, 'push');
            app.EndGameButton.ButtonPushedFcn = createCallbackFcn(app, @EndGameButtonPushed, true);
            app.EndGameButton.Position = [269 127 100 22];
            app.EndGameButton.Text = 'End Game';

            % Create EndgameButton
            app.EndgameButton = uibutton(app.UIFigure, 'push');
            app.EndgameButton.ButtonPushedFcn = createCallbackFcn(app, @EndgameButtonPushed, true);
            app.EndgameButton.Position = [269 267 100 22];
            app.EndgameButton.Text = 'End game';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [152 210 100 100];

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [152 20 100 100];

            % Create ScoreEditFieldLabel
            app.ScoreEditFieldLabel = uilabel(app.UIFigure);
            app.ScoreEditFieldLabel.HorizontalAlignment = 'right';
            app.ScoreEditFieldLabel.Position = [24 279 40 22];
            app.ScoreEditFieldLabel.Text = 'Score:';

            % Create ScoreEditField
            app.ScoreEditField = uieditfield(app.UIFigure, 'numeric');
            app.ScoreEditField.ValueChangedFcn = createCallbackFcn(app, @ScoreEditFieldValueChanged, true);
            app.ScoreEditField.Position = [79 279 35 22];

            % Create ScoreEditField_2Label
            app.ScoreEditField_2Label = uilabel(app.UIFigure);
            app.ScoreEditField_2Label.HorizontalAlignment = 'right';
            app.ScoreEditField_2Label.Position = [24 81 40 22];
            app.ScoreEditField_2Label.Text = 'Score:';

            % Create ScoreEditField_2
            app.ScoreEditField_2 = uieditfield(app.UIFigure, 'numeric');
            app.ScoreEditField_2.ValueChangedFcn = createCallbackFcn(app, @ScoreEditField_2ValueChanged, true);
            app.ScoreEditField_2.Position = [79 81 35 22];

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