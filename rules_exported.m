classdef rules_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        StartGameButton  matlab.ui.control.Button
        Label            matlab.ui.control.Label
        RulesLabel       matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: StartGameButton
        function StartGameButtonPushed(app, event)
            gameplay_public
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.7098 0.8 0.7373];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create RulesLabel
            app.RulesLabel = uilabel(app.UIFigure);
            app.RulesLabel.FontName = 'Hoefler Text';
            app.RulesLabel.FontSize = 45;
            app.RulesLabel.Position = [43 383 195 60];
            app.RulesLabel.Text = 'Rules ';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.WordWrap = 'on';
            app.Label.FontName = 'Hoefler Text';
            app.Label.FontSize = 19;
            app.Label.Position = [59 162 524 211];
            app.Label.Text = 'A player starts off by rolling two dice. The numbers on the dice are added and the player can choose whether to roll again. If they roll again, the new numbers are added to the old score. The player’s turn ends when they decide to stop rolling, or they roll a one. If one one is rolled, the player’s score for that turn is set to zero, and their turn ends. If two ones are rolled (snake eyes), the player’s score is set to zero for that round and all previous rounds, and the player’s turn ends. The game can be played with any number of players. Five rounds are played. At the end, players points are added up and the player with the most wins. ';

            % Create StartGameButton
            app.StartGameButton = uibutton(app.UIFigure, 'push');
            app.StartGameButton.ButtonPushedFcn = createCallbackFcn(app, @StartGameButtonPushed, true);
            app.StartGameButton.FontName = 'Hoefler Text';
            app.StartGameButton.FontSize = 13;
            app.StartGameButton.Position = [269 127 103 27];
            app.StartGameButton.Text = 'Start Game!';

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