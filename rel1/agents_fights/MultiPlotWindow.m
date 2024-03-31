classdef MultiPlotWindow
    properties
        xData
        yData
        numPlots
        windowRows
        windowCols
    end
    
    methods
        function obj = MultiPlotWindow(xData, yData)
            obj.numPlots = size(yData, 2);
            if obj.numPlots > 4
                error('Massimo 4 grafici sono supportati.');
            end

            % Costruttore della classe
            obj.xData = xData;
            obj.yData = yData;

            % Posizionamento grafici
            switch size(yData, 2)
                case {1,2}
                    obj.windowRows = 2;
                    obj.windowCols = 1;
                case {3,4}
                    obj.windowRows = 2;
                    obj.windowCols = 2;
                otherwise
                    error('Massimo 4 grafici sono supportati.');
            end
        end
        
        function plotWindow(obj)
            % Ottenere le dimensioni dello schermo
            screenSize = get(0,'ScreenSize');

            % Calcolare le dimensioni e la posizione della finestra
            windowWidth = screenSize(3);  % Larghezza dello schermo
            windowHeight = screenSize(4) - 50 - 80;  % Altezza dello schermo - 50 (parte alta dello schermo da lasciare libera)
            windowPositionX = 0;  % Posizione X della finestra
            windowPositionY = 50;  % Posizione Y della finestra

            % Creazione della finestra
            figure('Position', [windowPositionX, windowPositionY, windowWidth, windowHeight]); % Impostare la posizione e le dimensioni della finestra
           
            % Creazione dei sottografici
            for i = 1:obj.numPlots
                subplot(obj.windowRows, obj.windowCols, i);
                plot(obj.xData, obj.yData(:, i));
                title(['Grafico ', num2str(i)]);
                xlabel('x');
                ylabel(['y', num2str(i)]);
            end
        end
    end
end
