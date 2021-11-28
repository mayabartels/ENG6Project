classdef endgamescreen_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        Image3                matlab.ui.control.Image
        Image2                matlab.ui.control.Image
        Image                 matlab.ui.control.Image
        WinnerEditField       matlab.ui.control.EditField
        WinnerEditFieldLabel  matlab.ui.control.Label
        Label                 matlab.ui.control.Label
        ENDGAMELabel          matlab.ui.control.Label
        PlayAgainButton       matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)
        
        % Code that executes after component creation
        function startupFcn(app)
            global endingWinner
            disp(endingWinner)
            app.WinnerEditField.Value = endingWinner;
        end

        % Value changing function: WinnerEditField
        function WinnerEditFieldValueChanging(app, event)
            %NEED TO FILL
        end
        
        % Button pushed function: PlayAgainButton
        function PlayAgainButtonPushed(app, event)
            gameplay_public_exported
            close(app.UIFigure)
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

            % Create ENDGAMELabel
            app.ENDGAMELabel = uilabel(app.UIFigure);
            app.ENDGAMELabel.FontName = 'Hoefler Text';
            app.ENDGAMELabel.FontSize = 75;
            app.ENDGAMELabel.Position = [127 292 410 87];
            app.ENDGAMELabel.Text = 'END GAME';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [305 230 25 22];
            app.Label.Text = '';

            % Create WinnerEditFieldLabel
            app.WinnerEditFieldLabel = uilabel(app.UIFigure);
            app.WinnerEditFieldLabel.HorizontalAlignment = 'right';
            app.WinnerEditFieldLabel.Position = [169 263 46 22];
            app.WinnerEditFieldLabel.Text = 'Winner:';

            % Create WinnerEditField
            app.WinnerEditField = uieditfield(app.UIFigure, 'text');
            app.WinnerEditField.ValueChangingFcn = createCallbackFcn(app, @WinnerEditFieldValueChanging, true);
            app.WinnerEditField.Position = [230 263 100 22];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [16 60 210 204];
            app.Image.ImageSource = 'winnerSnakeGif.gif';

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [225 340 185 163];
            app.Image2.ImageSource = 'snakeGif.gif';

            % Create Image3
            app.Image3 = uiimage(app.UIFigure);
            app.Image3.Position = [409 66 215 192];
            app.Image3.ImageSource = 'Congratulations.gif';

            % Create PlayAgainButton
            app.PlayAgainButton = uibutton(app.UIFigure, 'push');
            app.PlayAgainButton.Position = [388 263 100 22];
            app.PlayAgainButton.ButtonPushedFcn = createCallbackFcn(app, @PlayAgainButtonPushed, true);
            app.PlayAgainButton.Text = 'Play Again';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = endgamescreen_exported

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