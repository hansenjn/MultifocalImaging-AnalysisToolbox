function ColorMapOut = InterpolatedColormap(ColormapIn,NumberPoints)
    %Function retunrs an interpolated colormap that contains as many
    %elements as requested
      
    Step = (NumberPoints-1)/(length(ColormapIn)-1);
    R = interp1(1:length(ColormapIn),ColormapIn(:,1),1:1/Step:length(ColormapIn));
    G = interp1(1:length(ColormapIn),ColormapIn(:,2),1:1/Step:length(ColormapIn));
    B = interp1(1:length(ColormapIn),ColormapIn(:,3),1:1/Step:length(ColormapIn));
    ColorMapOut = [R' G' B'];

return
end