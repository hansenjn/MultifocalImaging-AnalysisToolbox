
function Tubo4(X,Y,Z,R,SmoothingRequired,Shadow,Color)
% This function generates a tube-like plot of a 3D curve given by the
% points X,Y, and Z
% R sets the radius of this tube. This curve allows generating reflections
% to provide the viewer with some feeling of 3D on 3D curves. 
if nargin == 4
    SmoothingRequired = false;
end
if nargin == 5
    Shadow = false;
end
%% interpolating NaN and smoothing
X = InterpolationNaN(X);
Y = InterpolationNaN(Y);
Z = InterpolationNaN(Z);
if SmoothingRequired
    XSmooth = smooth(smooth(X));
    YSmooth = smooth(smooth(Y));
    ZSmooth = smooth(smooth(Z));
else
    XSmooth = X;
    YSmooth = Y;
    ZSmooth = Z;
end
if Shadow
    %% Plotting
    for I = 2:length(X)-1
        [XTube, YTube, ~] = cylinder2P(R, 20,[XSmooth(I-1) YSmooth(I-1) ZSmooth(I-1)],[XSmooth(I+1) YSmooth(I+1) ZSmooth(I+1)]);
%         surf(XTube,YTube,ZSmooth(I+1)*ones(size(YTube)),'edgecolor','none','FaceLighting','none','FaceColor',[0 0 0]);
        surf(XTube,YTube,zeros(size(YTube)),'edgecolor','none','FaceLighting','none','FaceColor',[0 0 0]);
        hold on
    end
else
    %% Plotting
    for I = 2:length(X)-1
        [XTube, YTube, ZTube] = cylinder2P(R, 20,[XSmooth(I-1) YSmooth(I-1) ZSmooth(I-1)],[XSmooth(I+1) YSmooth(I+1) ZSmooth(I+1)]);
        if nargin == 7
            surf(XTube,YTube,ZTube,'edgecolor','none','AmbientStrength',0.7,'FaceLighting','phong','FaceColor',Color);
        else
            surf(XTube,YTube,ZTube,'edgecolor','none','AmbientStrength',0.7,'FaceLighting','phong');
        end
        %        surf(XTube,YTube,zeros(size(ZTube)),'edgecolor','none','AmbientStrength',0.7,'FaceLighting','phong','FaceColor',[0 0 0]);
        hold on
    end
end
return
end

function [DataOut] = InterpolationNaN(DataIn,Method)

if nargin == 1
    Method = 'nearest';
end
    DataOut = DataIn;
     %% A basic function to interpolate the NaN points on the curve
    if sum(isnan(DataIn))>0
        RealLocs = find(~isnan(DataIn));
        NaNLocs = find(isnan(DataIn));
        try
            DataOut(NaNLocs) = interp1(RealLocs,DataIn(RealLocs,1),NaNLocs,Method)';
        catch
            DataOut(NaNLocs) = interp1(RealLocs,DataIn(1,RealLocs),NaNLocs,Method);
        end
    end
end