classdef endgamescreen_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        WinnerEditField       matlab.ui.control.EditField
        WinnerEditFieldLabel  matlab.ui.control.Label
        Label                 matlab.ui.control.Label
        ENDGAMELabel          matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changing function: WinnerEditField
        function WinnerEditFieldValueChanging(app, event)
            %NEED TO FILL
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
            app.ENDGAMELabel.Position = [127 303 446 76];
            app.ENDGAMELabel.Text = 'END GAME';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [305 230 25 22];
            app.Label.Text = '';

            % Create WinnerEditFieldLabel
            app.WinnerEditFieldLabel = uilabel(app.UIFigure);
            app.WinnerEditFieldLabel.HorizontalAlignment = 'right';
            app.WinnerEditFieldLabel.Position = [238 230 46 22];
            app.WinnerEditFieldLabel.Text = 'Winner:';

            % Create WinnerEditField
            app.WinnerEditField = uieditfield(app.UIFigure, 'text');
            app.WinnerEditField.ValueChangingFcn = createCallbackFcn(app, @WinnerEditFieldValueChanging, true);
            app.WinnerEditField.Position = [299 230 100 22];

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