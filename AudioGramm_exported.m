classdef AudioGramm_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        WYNIKIBADANIAPanel              matlab.ui.container.Panel
        WynikEditField                  matlab.ui.control.NumericEditField
        WynikLabel                      matlab.ui.control.Label
        powyej120dBcakowitaguchotaLabel  matlab.ui.control.Label
        dBgbokieuszkodzeniesuchuLabel   matlab.ui.control.Label
        dBznaczneuszkodzeniesuchuLabel  matlab.ui.control.Label
        do20dBnormaLabel                matlab.ui.control.Label
        dBumiarkowaneuszkodzeniesuchuLabel  matlab.ui.control.Label
        dBlekkieuszkodzeniesuchuLabel   matlab.ui.control.Label
        UbytekdBLabel                   matlab.ui.control.Label
        WYNIKIPanel                     matlab.ui.container.Panel
        GENERUJWYNIKButton              matlab.ui.control.Button
        UchoPraweEditField              matlab.ui.control.NumericEditField
        UchoPraweEditFieldLabel         matlab.ui.control.Label
        UchoLeweEditField               matlab.ui.control.NumericEditField
        UchoLeweEditFieldLabel          matlab.ui.control.Label
        BADANIESUCHUPanel               matlab.ui.container.Panel
        GdyniesyszyszdwikuzwikszpoziomsygnauLabel  matlab.ui.control.Label
        GdyusysyszdwiknacinijSYSZLabel  matlab.ui.control.Label
        NaleydokonapomiarudlawszystkichczstotlwiociLabel  matlab.ui.control.Label
        StronaDropDown                  matlab.ui.control.DropDown
        StronaDropDownLabel             matlab.ui.control.Label
        SYSZButton                      matlab.ui.control.Button
        PLAYButton                      matlab.ui.control.Button
        CzstotlwoHzDropDown             matlab.ui.control.DropDown
        CzstotlwoHzDropDownLabel        matlab.ui.control.Label
        PoziomsygnaudBDropDown          matlab.ui.control.DropDown
        PoziomsygnaudBDropDownLabel     matlab.ui.control.Label
        KALIBRACJAPanel                 matlab.ui.container.Panel
        STARTButton                     matlab.ui.control.Button
        RafaPaaszewskiLabel             matlab.ui.control.Label
        BartoszDrumiskiLabel            matlab.ui.control.Label
        AUDIOGRAMLabel                  matlab.ui.control.Label
    end

    
    properties (Access = private)
        UchoLewe = 0;
        UchoPrawe = 0;
        
        %tworzenie tablic, do których wpisane zostaną wyniki
        UchoLeweAmplituda = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        UchoLeweCzestotliwosc = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        UchoPraweAmplituda = [0, 0, 0, 0, 0, 0, 0, 0, 0];
        UchoPraweCzestotliwosc = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: CzstotlwoHzDropDown
        function CzstotlwoHzDropDownValueChanged(app, event)
            %value = app.CzstotlwoHzDropDown.Value;
            
        end

        % Value changed function: PoziomsygnaudBDropDown
        function PoziomsygnaudBDropDownValueChanged(app, event)
            %value = app.PoziomsygnaudBDropDown.Value;
            
        end

        % Button pushed function: PLAYButton
        function PLAYButtonPushed(app, event)
            
            % pobranie wartosci ustawionej czestotliwosci
            f1 = app.CzstotlwoHzDropDown.Value;
            % pobranie wartosci ustawionego poziomu sygnalu
            a1 = app.PoziomsygnaudBDropDown.Value;
            
            %konwersja ze String na double
            czestotliwosc = str2double(f1);
            amplituda = str2double(a1);
            
            % f probkowania
            fs = 48000;
            % okres
            t=0:1/fs:1;
            
            % sygnal
            %y = amplituda * sin(2*pi*czestotliwosc*t);
            
            sygnal = 1 * sin(2*pi*t* czestotliwosc);
            
            % generowanie sygnalu wg. wzoru z kalibracji z instrukcji
            
            wspolczynnik = 10.^(amplituda/20);
            
            y = sygnal.*wspolczynnik; 
            
            
            % odtwarzanie sygnalu w zaleznosci od wybranej strony
            % wypelnia sie  prawa lub lewa "czesc" sygnalu stereo zerami
            % rozwiazanie wg. forum Matlab
            
            if (app.StronaDropDown.Value == "Lewa")
                wyjscie = [y; zeros(size(t))]';
            elseif (app.StronaDropDown.Value == "Prawa")
                wyjscie = [zeros(size(t)); y]';
            end
            
            
            sound(wyjscie, fs)
            
            
           
            pause(5);
            clear sound;
            
        end

        % Button pushed function: STARTButton
        function STARTButtonPushed(app, event)
            %Kalibracja
            fsmsg = msgbox('Teraz dokonamy kalibracji. Ustaw glośność tak, aby słyszany był tylko głośniejszy ton!');
            
            fs=48000;
            f=1000;
            t=0:1/fs:1;
            A=1;
            y=A*sin(2*pi*f*t);
            Py=10*log10(sum(y.^2));
            coef=10.^(5/20);
            yy=y.*coef;
            Pyy=10*log10(sum(yy.^2));
            zz=[];
            for i=1:10
                z1=y(1,1:48000);
                z2=yy(1,1:48000);
                zz=[zz z1 z2]; 
            end
            z4=zz/max(abs(zz));
           % plot(z4);
            
            soundsc(z4,fs);
            pause(8);
            clear sound;
        end

        % Button pushed function: GENERUJWYNIKButton
        function GENERUJWYNIKButtonPushed(app, event)
            
            %generowanie wyników według zaleceń z instrukcji
            if (app.UchoPraweAmplituda(4) - app.UchoPraweAmplituda(2) > 40)
                app.UchoPraweEditField.Value = (app.UchoPraweAmplituda(2) + app.UchoPraweAmplituda(3) + app.UchoPraweAmplituda(3) + app.UchoPraweAmplituda(4)) /4;
                elseif (app.UchoPraweAmplituda(4) - app.UchoPraweAmplituda(2) > 40 && app.UchoPraweAmplituda(6) > app.UchoPraweAmplituda(4))
                app.UchoPraweEditField.Value = (app.UchoPraweAmplituda(2) + app.UchoPraweAmplituda(3) + app.UchoPraweAmplituda(5)) / 3;
                else
                app.UchoPraweEditField.Value = (app.UchoPraweAmplituda(2) + app.UchoPraweAmplituda(3) + app.UchoPraweAmplituda(4)) / 3;
            end
            
            if (app.UchoLeweAmplituda(4) - app.UchoLeweAmplituda(2) > 40)
                app.UchoLeweEditField.Value = (app.UchoLeweAmplituda(2) + app.UchoLeweAmplituda(3) + app.UchoLeweAmplituda(3) + app.UchoLeweAmplituda(4)) /4;
            elseif (app.UchoLeweAmplituda(4) - app.UchoLeweAmplituda(2) > 40 && app.UchoLeweAmplituda(6) > app.UchoLeweAmplituda(4))
                app.UchoLeweEditField.Value = (app.UchoLeweAmplituda(2) + app.UchoLeweAmplituda(3) + app.UchoLeweAmplituda(5)) / 3;
                else
                app.UchoLeweEditField.Value = (app.UchoLeweAmplituda(2) + app.UchoLeweAmplituda(3) + app.UchoLeweAmplituda(4)) / 3;
            end
            
            if (app.UchoLeweEditField.Value > (app.UchoPraweEditField.Value + 25)  )
                app.WynikEditField.Value = app.UchoPraweEditField.Value +5;
                
            else if (app.UchoPraweEditField.Value > (app.UchoLeweEditField.Value + 25) )
                app.WynikEditField.Value = app.UchoLeweEditField.Value + 5;
            else
                if (app.UchoLeweEditField.Value > app.UchoPraweEditField.Value && app.UchoLeweEditField.Value - (app.UchoPraweEditField.Value + 25) < 0 )
                    app.WynikEditField.Value = app.UchoPraweEditField.Value;
                else
                    app.WynikEditField.Value = app.UchoLeweEditField.Value;
                end
            end
            
            end
            
            plot( app.UchoLeweCzestotliwosc,  app.UchoLeweAmplituda,app.UchoLeweCzestotliwosc, app.UchoPraweAmplituda );
            xlabel('Częstotliwość [Hz]');
            ylabel('Ubytek słuchu w dB');
            set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
            legend('ucho lewe', 'ucho prawe');
            
           
        end

        % Button pushed function: SYSZButton
        function SYSZButtonPushed(app, event)
             % pobranie wartosci ustawionej czestotliwosci
            f1 = app.CzstotlwoHzDropDown.Value;
            % pobranie wartosci ustawionego poziomu sygnalu
            a1 = app.PoziomsygnaudBDropDown.Value;
            
            %konwersja ze String na double
            czestotliwosc = str2double(f1);
            amplituda = str2double(a1);
            
           %wpisywanie do tablic
        
            if (app.StronaDropDown.Value == "Prawa")  
                  if (czestotliwosc == 125)
                    app.UchoPraweCzestotliwosc(1) = czestotliwosc;
                    app.UchoPraweAmplituda(1) = amplituda;
                elseif (czestotliwosc == 500)
                    app.UchoPraweCzestotliwosc(2) = czestotliwosc;
                    app.UchoPraweAmplituda(2) = amplituda;
                elseif (czestotliwosc == 1000)
                    app.UchoPraweCzestotliwosc(3) = czestotliwosc;
                    app.UchoPraweAmplituda(3) = amplituda; 
                elseif (czestotliwosc == 2000)
                    app.UchoPraweCzestotliwosc(4) = czestotliwosc;
                    app.UchoPraweAmplituda(4) = amplituda;
                elseif (czestotliwosc == 3000)
                    app.UchoPraweCzestotliwosc(5) = czestotliwosc;
                    app.UchoPraweAmplituda(5) = amplituda;
                elseif (czestotliwosc == 4000)
                    app.UchoPraweCzestotliwosc(6) = czestotliwosc;
                    app.UchoPraweAmplituda(6) = amplituda;
                elseif (czestotliwosc == 6000)
                    app.UchoPraweCzestotliwosc(7) = czestotliwosc;
                    app.UchoPraweAmplituda(7) = amplituda;
                elseif (czestotliwosc == 8000)
                    app.UchoPraweCzestotliwosc(8) = czestotliwosc;
                    app.UchoPraweAmplituda(8) = amplituda;
                elseif (czestotliwosc == 10000)
                    app.UchoPraweCzestotliwosc(9) = czestotliwosc;
                    app.UchoPraweAmplituda(9) = amplituda;
                end    
            
            else if (app.StronaDropDown.Value == "Lewa")
                if (czestotliwosc == 125)
                    app.UchoLeweCzestotliwosc(1) = czestotliwosc;
                    app.UchoLeweAmplituda(1) = amplituda;
                elseif (czestotliwosc == 500)
                    app.UchoLeweCzestotliwosc(2) = czestotliwosc;
                    app.UchoLeweAmplituda(2) = amplituda;
                elseif (czestotliwosc == 1000)
                    app.UchoLeweCzestotliwosc(3) = czestotliwosc;
                    app.UchoLeweAmplituda(3) = amplituda;  
                elseif (czestotliwosc == 2000)
                    app.UchoLeweCzestotliwosc(4) = czestotliwosc;
                    app.UchoLeweAmplituda(4) = amplituda; 
                elseif (czestotliwosc == 3000)
                    app.UchoLeweCzestotliwosc(5) = czestotliwosc;
                    app.UchoLeweAmplituda(5) = amplituda;
                elseif (czestotliwosc == 4000)
                    app.UchoLeweCzestotliwosc(6) = czestotliwosc;
                    app.UchoLeweAmplituda(6) = amplituda;
                elseif (czestotliwosc == 6000)
                    app.UchoLeweCzestotliwosc(7) = czestotliwosc;
                    app.UchoLeweAmplituda(7) = amplituda;
                elseif (czestotliwosc == 8000)
                    app.UchoLeweCzestotliwosc(8) = czestotliwosc;
                    app.UchoLeweAmplituda(8) = amplituda;
                elseif (czestotliwosc == 10000)
                    app.UchoLeweCzestotliwosc(9) = czestotliwosc;
                    app.UchoLeweAmplituda(9) = amplituda;
                end       
            
            end    
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 904 402];
            app.UIFigure.Name = 'MATLAB App';

            % Create AUDIOGRAMLabel
            app.AUDIOGRAMLabel = uilabel(app.UIFigure);
            app.AUDIOGRAMLabel.FontName = 'Adobe Arabic';
            app.AUDIOGRAMLabel.FontSize = 22;
            app.AUDIOGRAMLabel.FontWeight = 'bold';
            app.AUDIOGRAMLabel.Position = [401 363 117 25];
            app.AUDIOGRAMLabel.Text = 'AUDIOGRAM';

            % Create BartoszDrumiskiLabel
            app.BartoszDrumiskiLabel = uilabel(app.UIFigure);
            app.BartoszDrumiskiLabel.FontSize = 8;
            app.BartoszDrumiskiLabel.FontWeight = 'bold';
            app.BartoszDrumiskiLabel.Position = [100 8 76 22];
            app.BartoszDrumiskiLabel.Text = 'Bartosz Drumiński';

            % Create RafaPaaszewskiLabel
            app.RafaPaaszewskiLabel = uilabel(app.UIFigure);
            app.RafaPaaszewskiLabel.FontSize = 8;
            app.RafaPaaszewskiLabel.FontWeight = 'bold';
            app.RafaPaaszewskiLabel.Position = [23 8 74 22];
            app.RafaPaaszewskiLabel.Text = {'Rafał Pałaszewski'; ''};

            % Create KALIBRACJAPanel
            app.KALIBRACJAPanel = uipanel(app.UIFigure);
            app.KALIBRACJAPanel.Title = 'KALIBRACJA';
            app.KALIBRACJAPanel.Position = [34 289 160 92];

            % Create STARTButton
            app.STARTButton = uibutton(app.KALIBRACJAPanel, 'push');
            app.STARTButton.ButtonPushedFcn = createCallbackFcn(app, @STARTButtonPushed, true);
            app.STARTButton.Position = [23 21 121 37];
            app.STARTButton.Text = 'START';

            % Create BADANIESUCHUPanel
            app.BADANIESUCHUPanel = uipanel(app.UIFigure);
            app.BADANIESUCHUPanel.Title = 'BADANIE SŁUCHU';
            app.BADANIESUCHUPanel.Position = [35 50 413 231];

            % Create PoziomsygnaudBDropDownLabel
            app.PoziomsygnaudBDropDownLabel = uilabel(app.BADANIESUCHUPanel);
            app.PoziomsygnaudBDropDownLabel.HorizontalAlignment = 'right';
            app.PoziomsygnaudBDropDownLabel.Position = [6 137 112 22];
            app.PoziomsygnaudBDropDownLabel.Text = 'Poziom sygnału[dB]';

            % Create PoziomsygnaudBDropDown
            app.PoziomsygnaudBDropDown = uidropdown(app.BADANIESUCHUPanel);
            app.PoziomsygnaudBDropDown.Items = {'0', '10', '30', '50', '70', '90', '110', '130', '140'};
            app.PoziomsygnaudBDropDown.ValueChangedFcn = createCallbackFcn(app, @PoziomsygnaudBDropDownValueChanged, true);
            app.PoziomsygnaudBDropDown.Position = [132 137 100 22];
            app.PoziomsygnaudBDropDown.Value = '0';

            % Create CzstotlwoHzDropDownLabel
            app.CzstotlwoHzDropDownLabel = uilabel(app.BADANIESUCHUPanel);
            app.CzstotlwoHzDropDownLabel.HorizontalAlignment = 'right';
            app.CzstotlwoHzDropDownLabel.Position = [15 169 101 22];
            app.CzstotlwoHzDropDownLabel.Text = 'Częstotlwość [Hz]';

            % Create CzstotlwoHzDropDown
            app.CzstotlwoHzDropDown = uidropdown(app.BADANIESUCHUPanel);
            app.CzstotlwoHzDropDown.Items = {'125', '500', '1000', '2000', '3000', '4000', '6000', '8000', '10000'};
            app.CzstotlwoHzDropDown.ValueChangedFcn = createCallbackFcn(app, @CzstotlwoHzDropDownValueChanged, true);
            app.CzstotlwoHzDropDown.Position = [132 169 100 22];
            app.CzstotlwoHzDropDown.Value = '125';

            % Create PLAYButton
            app.PLAYButton = uibutton(app.BADANIESUCHUPanel, 'push');
            app.PLAYButton.ButtonPushedFcn = createCallbackFcn(app, @PLAYButtonPushed, true);
            app.PLAYButton.Position = [287 114 106 56];
            app.PLAYButton.Text = 'PLAY';

            % Create SYSZButton
            app.SYSZButton = uibutton(app.BADANIESUCHUPanel, 'push');
            app.SYSZButton.ButtonPushedFcn = createCallbackFcn(app, @SYSZButtonPushed, true);
            app.SYSZButton.BackgroundColor = [1 1 0];
            app.SYSZButton.Position = [286 22 107 72];
            app.SYSZButton.Text = 'SŁYSZĘ';

            % Create StronaDropDownLabel
            app.StronaDropDownLabel = uilabel(app.BADANIESUCHUPanel);
            app.StronaDropDownLabel.HorizontalAlignment = 'right';
            app.StronaDropDownLabel.Position = [79 104 41 22];
            app.StronaDropDownLabel.Text = 'Strona';

            % Create StronaDropDown
            app.StronaDropDown = uidropdown(app.BADANIESUCHUPanel);
            app.StronaDropDown.Items = {'Prawa', 'Lewa'};
            app.StronaDropDown.Position = [134 104 100 22];
            app.StronaDropDown.Value = 'Prawa';

            % Create NaleydokonapomiarudlawszystkichczstotlwiociLabel
            app.NaleydokonapomiarudlawszystkichczstotlwiociLabel = uilabel(app.BADANIESUCHUPanel);
            app.NaleydokonapomiarudlawszystkichczstotlwiociLabel.FontSize = 10;
            app.NaleydokonapomiarudlawszystkichczstotlwiociLabel.Position = [23 22 251 22];
            app.NaleydokonapomiarudlawszystkichczstotlwiociLabel.Text = 'Należy dokonać pomiaru dla wszystkich częstotlwiości!';

            % Create GdyusysyszdwiknacinijSYSZLabel
            app.GdyusysyszdwiknacinijSYSZLabel = uilabel(app.BADANIESUCHUPanel);
            app.GdyusysyszdwiknacinijSYSZLabel.FontSize = 10;
            app.GdyusysyszdwiknacinijSYSZLabel.Position = [23 72 185 22];
            app.GdyusysyszdwiknacinijSYSZLabel.Text = 'Gdy usłysysz dźwięk, naciśnij "SŁYSZĘ"';

            % Create GdyniesyszyszdwikuzwikszpoziomsygnauLabel
            app.GdyniesyszyszdwikuzwikszpoziomsygnauLabel = uilabel(app.BADANIESUCHUPanel);
            app.GdyniesyszyszdwikuzwikszpoziomsygnauLabel.FontSize = 10;
            app.GdyniesyszyszdwikuzwikszpoziomsygnauLabel.Position = [24 47 236 22];
            app.GdyniesyszyszdwikuzwikszpoziomsygnauLabel.Text = 'Gdy nie słyszysz dźwięku, zwiększ poziom sygnału!';

            % Create WYNIKIBADANIAPanel
            app.WYNIKIBADANIAPanel = uipanel(app.UIFigure);
            app.WYNIKIBADANIAPanel.Title = 'WYNIKI BADANIA';
            app.WYNIKIBADANIAPanel.Position = [461 50 427 314];

            % Create UchoLeweEditFieldLabel
            app.UchoLeweEditFieldLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.UchoLeweEditFieldLabel.HorizontalAlignment = 'right';
            app.UchoLeweEditFieldLabel.Position = [14 158 69 22];
            app.UchoLeweEditFieldLabel.Text = 'Ucho Lewe:';

            % Create UchoLeweEditField
            app.UchoLeweEditField = uieditfield(app.WYNIKIBADANIAPanel, 'numeric');
            app.UchoLeweEditField.Position = [98 158 42 22];

            % Create UchoPraweEditFieldLabel
            app.UchoPraweEditFieldLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.UchoPraweEditFieldLabel.HorizontalAlignment = 'right';
            app.UchoPraweEditFieldLabel.Position = [150 158 74 22];
            app.UchoPraweEditFieldLabel.Text = 'Ucho Prawe:';

            % Create UchoPraweEditField
            app.UchoPraweEditField = uieditfield(app.WYNIKIBADANIAPanel, 'numeric');
            app.UchoPraweEditField.Position = [239 158 45 22];

            % Create WYNIKIPanel
            app.WYNIKIPanel = uipanel(app.WYNIKIBADANIAPanel);
            app.WYNIKIPanel.Title = 'WYNIKI';
            app.WYNIKIPanel.Position = [139 222 145 66];

            % Create GENERUJWYNIKButton
            app.GENERUJWYNIKButton = uibutton(app.WYNIKIPanel, 'push');
            app.GENERUJWYNIKButton.ButtonPushedFcn = createCallbackFcn(app, @GENERUJWYNIKButtonPushed, true);
            app.GENERUJWYNIKButton.Position = [11 8 121 28];
            app.GENERUJWYNIKButton.Text = {'GENERUJ WYNIK'; ''};

            % Create UbytekdBLabel
            app.UbytekdBLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.UbytekdBLabel.Position = [177 190 68 22];
            app.UbytekdBLabel.Text = 'Ubytek [dB]';

            % Create dBlekkieuszkodzeniesuchuLabel
            app.dBlekkieuszkodzeniesuchuLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.dBlekkieuszkodzeniesuchuLabel.Position = [23 117 211 18];
            app.dBlekkieuszkodzeniesuchuLabel.Text = '20 - 40dB = lekkie uszkodzenie słuchu';

            % Create dBumiarkowaneuszkodzeniesuchuLabel
            app.dBumiarkowaneuszkodzeniesuchuLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.dBumiarkowaneuszkodzeniesuchuLabel.Position = [23 101 253 14];
            app.dBumiarkowaneuszkodzeniesuchuLabel.Text = '40 - 70dB = umiarkowane uszkodzenie słuchu';

            % Create do20dBnormaLabel
            app.do20dBnormaLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.do20dBnormaLabel.Position = [23 133 253 19];
            app.do20dBnormaLabel.Text = 'do 20dB = norma';

            % Create dBznaczneuszkodzeniesuchuLabel
            app.dBznaczneuszkodzeniesuchuLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.dBznaczneuszkodzeniesuchuLabel.Position = [23 80 253 22];
            app.dBznaczneuszkodzeniesuchuLabel.Text = '70 - 90dB = znaczne uszkodzenie słuchu';

            % Create dBgbokieuszkodzeniesuchuLabel
            app.dBgbokieuszkodzeniesuchuLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.dBgbokieuszkodzeniesuchuLabel.Position = [23 64 253 17];
            app.dBgbokieuszkodzeniesuchuLabel.Text = '90 - 120dB = głębokie uszkodzenie słuchu';

            % Create powyej120dBcakowitaguchotaLabel
            app.powyej120dBcakowitaguchotaLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.powyej120dBcakowitaguchotaLabel.Position = [23 43 253 22];
            app.powyej120dBcakowitaguchotaLabel.Text = 'powyżej 120dB = całkowita głuchota';

            % Create WynikLabel
            app.WynikLabel = uilabel(app.WYNIKIBADANIAPanel);
            app.WynikLabel.HorizontalAlignment = 'right';
            app.WynikLabel.Position = [305 158 41 22];
            app.WynikLabel.Text = 'Wynik:';

            % Create WynikEditField
            app.WynikEditField = uieditfield(app.WYNIKIBADANIAPanel, 'numeric');
            app.WynikEditField.Position = [361 158 46 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AudioGramm_exported

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