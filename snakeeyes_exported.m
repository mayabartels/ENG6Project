classdef snakeeyes_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        Player2EditField       matlab.ui.control.EditField
        Player2EditFieldLabel  matlab.ui.control.Label
        ReadyButton            matlab.ui.control.Button
        Player1EditField       matlab.ui.control.EditField
        Player1EditFieldLabel  matlab.ui.control.Label
        SNAKEEYESLabel         matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ReadyButton
        function ReadyButtonPushed(app, event)
            rules
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.7098 0.8 0.7373];
            app.UIFigure.Position = [100 100 646 483];
            app.UIFigure.Name = 'MATLAB App';

            % Create SNAKEEYESLabel
            app.SNAKEEYESLabel = uilabel(app.UIFigure);
            app.SNAKEEYESLabel.HorizontalAlignment = 'center';
            app.SNAKEEYESLabel.FontName = 'Hoefler Text';
            app.SNAKEEYESLabel.FontSize = 70;
            app.SNAKEEYESLabel.Position = [65 247 520 166];
            app.SNAKEEYESLabel.Text = 'SNAKE EYES';

            % Create Player1EditFieldLabel
            app.Player1EditFieldLabel = uilabel(app.UIFigure);
            app.Player1EditFieldLabel.HorizontalAlignment = 'right';
            app.Player1EditFieldLabel.Position = [223 258 49 22];
            app.Player1EditFieldLabel.Text = 'Player 1';

            % Create Player1EditField
            app.Player1EditField = uieditfield(app.UIFigure, 'text');
            app.Player1EditField.Position = [287 258 139 22];

            % Create ReadyButton
            app.ReadyButton = uibutton(app.UIFigure, 'push');
            app.ReadyButton.ButtonPushedFcn = createCallbackFcn(app, @ReadyButtonPushed, true);
            app.ReadyButton.FontName = 'Hoefler Text';
            app.ReadyButton.Position = [275 165 100 22];
            app.ReadyButton.Text = 'Ready?';

            % Create Player2EditFieldLabel
            app.Player2EditFieldLabel = uilabel(app.UIFigure);
            app.Player2EditFieldLabel.HorizontalAlignment = 'right';
            app.Player2EditFieldLabel.Position = [223 217 49 22];
            app.Player2EditFieldLabel.Text = 'Player 2';

            % Create Player2EditField
            app.Player2EditField = uieditfield(app.UIFigure, 'text');
            app.Player2EditField.Position = [287 217 139 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = snakeeyes_exported

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