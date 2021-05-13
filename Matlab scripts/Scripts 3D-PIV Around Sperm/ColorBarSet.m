function h = ColorBarSet(Label,TickValues,varargin)
    h = colorbar;
    q = get(h,'Label');
    set(q,'String',Label);
    LimitsBar = h.Limits;
    TickLabel = cell(1,length(TickValues));
    Ticks = zeros(1,length(TickValues));
    for I = 1:length(TickValues)
        Ticks(I) = LimitsBar(1) + (TickValues(I) - TickValues(1))*(LimitsBar(end) - LimitsBar(1))/(TickValues(end) - TickValues(1));  
        TickLabel{I} = num2str(TickValues(I));
    end
    h.Ticks = Ticks;
    h.TickLabels = TickLabel;       
    for I = 1:2:nargin-3
        set(h,varargin{I},varargin{I+1})
    end
end