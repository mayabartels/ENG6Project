classdef rules_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        Image2           matlab.ui.control.Image
        Image            matlab.ui.control.Image
        StartGameButton  matlab.ui.control.Button
        Label            matlab.ui.control.Label
        RulesLabel       matlab.ui.control.Label
        Player1NameEditFieldLabel  matlab.ui.control.Label
        Player1NameEditField       matlab.ui.control.EditField
        Player2NameEditFieldLabel  matlab.ui.control.Label
        Player2NameEditField       matlab.ui.control.EditField
        
        % Temporarily Store Names
        Player1Name
        Player2Name
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartGameButton
        function StartGameButtonPushed(app, event)
            % Open gameplay screen and close Rules
            gameplay_public_exported
            close(app.UIFigure)
            
            % Make accessible by gameplay script
            %app.rules_exported = rulesScreen;

            % Audio commands
            [y,Fs] = audioread("snakeHiss.wav");
            sound(y,Fs)
        end
        
        % Value changed function: Player1NameEditField
        function Player1NameEditFieldValueChanged(app, event)
            app.Player1Name = app.Player1NameEditField.Value;
            disp(app.Player1Name)
            
        end

        % Value changed function: Player2NameEditField
        function Player2NameEditFieldValueChanged(app, event)
            app.Player2Name = app.Player2NameEditField.Value;
            disp(app.Player2Name)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.3529 0.9098 0.5216];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';


           % Create RulesLabel
            app.RulesLabel = uilabel(app.UIFigure);
            app.RulesLabel.FontName = 'Snap ITC';
            app.RulesLabel.FontSize = 55;
            app.RulesLabel.FontWeight = 'bold';
            app.RulesLabel.Position = [201 368 239 77];
            app.RulesLabel.Text = 'Rules ';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.WordWrap = 'on';
            app.Label.FontName = 'Hoefler Text';
            app.Label.FontSize = 19;
            app.Label.Position = [43 114 537 255];
            app.Label.Text = 'A player starts off by rolling two dice. The numbers on the dice are added and the player can choose whether to roll again. If they roll again, the new numbers are added to the old score. The player’s turn ends when they decide to stop rolling, or they roll a one. If one one is rolled, the player’s score for that turn is set to zero, and their turn ends. If two ones are rolled (snake eyes), the player’s score is set to zero for that round and all previous rounds, and the player’s turn ends. The game can be played with any number of players. Five rounds are played. At the end, players points are added up and the player with the most wins. ';
            
            % Create StartGameButton
            app.StartGameButton = uibutton(app.UIFigure, 'push');
            app.StartGameButton.ButtonPushedFcn = createCallbackFcn(app, @StartGameButtonPushed, true);
            app.StartGameButton.FontName = 'Hoefler Text';
            app.StartGameButton.FontSize = 13;
            app.StartGameButton.Position = [269 81 103 27];
            app.StartGameButton.Text = 'Start Game!';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [30 15 172 125];
            app.Image.ImageSource = 'snakeGif.gif';

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [431 8 177 139];
            app.Image2.ImageSource = 'SnakeEyesGif.gif';

             % Create Player1NameEditFieldLabel
            app.Player1NameEditFieldLabel = uilabel(app.UIFigure);
            app.Player1NameEditFieldLabel.HorizontalAlignment = 'right';
            app.Player1NameEditFieldLabel.Position = [408 410 85 22];
            app.Player1NameEditFieldLabel.Text = 'Player 1 Name';

            % Create Player1NameEditField
            app.Player1NameEditField = uieditfield(app.UIFigure, 'text');
            app.Player1NameEditField.ValueChangedFcn = createCallbackFcn(app, @Player1NameEditFieldValueChanged, true);
            app.Player1NameEditField.Position = [508 410 100 22];

            % Create Player2NameEditFieldLabel
            app.Player2NameEditFieldLabel = uilabel(app.UIFigure);
            app.Player2NameEditFieldLabel.HorizontalAlignment = 'right';
            app.Player2NameEditFieldLabel.Position = [408 377 85 22];
            app.Player2NameEditFieldLabel.Text = 'Player 2 Name';

            % Create Player2NameEditField
            app.Player2NameEditField = uieditfield(app.UIFigure, 'text');
            app.Player2NameEditField.ValueChangedFcn = createCallbackFcn(app, @Player2NameEditFieldValueChanged, true);
            app.Player2NameEditField.Position = [508 377 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = rules_exported

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