function BoxPlotStdv (Data,Position,Label)

%% generates a boxplot on the position required with a red line indicating the mean value and a blue box for the standard deviation
    set (gca,'XTick', 1:100);
    KeepHoldStatus = ishold;
    plot (ones(1,length(Data))*(Position),Data,'ok','MarkerSize',4,'MarkerFaceColor','k')
    hold all
    [MeanData, StdData] = MeanStdDev(Data);
%     [MeanData StdData] = MeanStdError(Data);
    plot ([0.77 1.23] + Position-1,[1 1]*MeanData,'r','linewidth',3);
    plot ([0.74 1.26] + Position-1,[1 1]*MeanData + StdData,'b','linewidth',2);
    plot ([0.74 1.26] + Position-1,[1 1]*MeanData - StdData,'b','linewidth',2);
    plot ([0.74 0.74] + Position-1,[(MeanData + StdData) (MeanData - StdData)],'b','linewidth',2);
    plot ([1.26 1.26] + Position-1,[(MeanData + StdData) (MeanData - StdData)],'b','linewidth',2);
    OldLabel = get (gca,'XTickLabel');
    OldLabelCell = cell(1,length(OldLabel));
    for I = 1:length(OldLabel)
        OldLabelCell {I} = char(OldLabel(I));
    end
    NewLabelCell = OldLabelCell;
    NewLabelCell{Position} = Label;
    set (gca,'XTickLabel',NewLabelCell);
    if ~KeepHoldStatus
        hold off
    end

return
end

function [Mean, Error, NumberOfElements] = MeanStdDev (varargin)
    % This function evaluates the mean, standard deviation and the number of
    % elements on an array based only on the finite elements found on
    % that array; If there are more than one vector input of identical length N, the program interprets
    % that you want to calculate N mean and standard deviations taking
    % elements of each vector on the index i to calculate the mean and
    % StdDeviation.
    
    if nargin == 1    
        Vector = varargin {1};
        Finite = isfinite (Vector);

        % First we evaluate the mean value
        NumberOfElements = sum(isfinite(Vector));
        Mean = sum(Vector(isfinite(Vector)))/NumberOfElements;

        % Now the standard error is calculated
        Accum = 0;
        for J = 1:length(Vector)
               if Finite(J) == 1 
                   Accum = Accum + (Vector(J)-Mean)^2;
               end
        end 
        Error = sqrt(Accum/NumberOfElements);
        return;
    else       
        NumberOfElements = nargin;
        AccumulatedVector = zeros(length(varargin{1}),2);
        Error = zeros(length(varargin{1}),1);
        
        for I=1:nargin
            Vector = varargin{I};
            for J = 1:length(varargin{1})
                if isfinite(Vector(J))
                    AccumulatedVector(J,1) = AccumulatedVector(J,1) + Vector(J);
                    AccumulatedVector(J,2) = AccumulatedVector(J,2) + 1;
                end
            end
        end
        Mean = AccumulatedVector(:,1)./AccumulatedVector(:,2);
        for J = 1:length(varargin{1})
            if isfinite(Mean(J))
               Accum = 0;              
               for I = 1:nargin
                   Vector = varargin{I};
                   Accum = Accum + (Vector(J)-Mean(J))^2;
               end
            else
                Accum = NaN;
            end
            Error(J,1) = sqrt(Accum/NumberOfElements);
        end
        
    end
   
end
