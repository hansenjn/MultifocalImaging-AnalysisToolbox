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