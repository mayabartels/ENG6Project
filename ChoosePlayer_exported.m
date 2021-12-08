classdef ChoosePlayer_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        Player1CheckBox  matlab.ui.control.CheckBox
        Player2CheckBox  matlab.ui.control.CheckBox
        ChoosewhichplayeryouwillplayasLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Create global variables for player1 and player2 turns
            global player1Turn;
            global player2Turn;
            
            % Set initial values for player1Turn and player2Turn to false
            player1Turn = false;
            player2Turn = false;
        end
        
        % Value changed function: Player1CheckBox
        function Player1CheckBoxValueChanged(app, event)
            % Import global variable for player turn
            global player1Turn;
            
            % If 
            if ~player1Turn
                player1Turn = true;
            elseif player1Turn
                player1Turn = ~player1Turn;
            end
            
            disp(player1Turn)
        end

        % Value changed function: Player2CheckBox
        function Player2CheckBoxValueChanged(app, event)
            % Import global variable for player turn
            global player2Turn;
            
            % If 
            if ~player2Turn
                player2Turn = true;
            elseif player2Turn
                player2Turn = ~player2Turn;
            end
            
            disp(player2Turn)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 243 133];
            app.UIFigure.Name = 'MATLAB App';

            % Create Player1CheckBox
            app.Player1CheckBox = uicheckbox(app.UIFigure);
            app.Player1CheckBox.ValueChangedFcn = createCallbackFcn(app, @Player1CheckBoxValueChanged, true);
            app.Player1CheckBox.Text = 'Player 1';
            app.Player1CheckBox.Position = [90 52 66 30];

            % Create Player2CheckBox
            app.Player2CheckBox = uicheckbox(app.UIFigure);
            app.Player2CheckBox.ValueChangedFcn = createCallbackFcn(app, @Player2CheckBoxValueChanged, true);
            app.Player2CheckBox.Text = 'Player 2';
            app.Player2CheckBox.Position = [90 29 66 22];

            % Create ChoosewhichplayeryouwillplayasLabel
            app.ChoosewhichplayeryouwillplayasLabel = uilabel(app.UIFigure);
            app.ChoosewhichplayeryouwillplayasLabel.Position = [22 97 202 22];
            app.ChoosewhichplayeryouwillplayasLabel.Text = 'Choose which player you will play as';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ChoosePlayer_exported

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