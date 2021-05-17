%% Global particle plot

%% Getting particle tracks
%% defining parameters
Settings = struct;
Settings.PixelSize = 1; % in µm per pixel. Conversion not needed for this data, as the positions are already in µm
Settings.AcquisitionRate = 500; %Frames per second    
Settings.MaxVelocity = 550;% Filter for the particle velocity in µm per s
Settings.MinTrackDuration = 10; % Number of time points
Settings.MinTrackExtension = 2; % Start to end extension of the track. This is to avoid non-moving particles
Settings.InterpolateGaps = 1; % yes or no interpolation
Settings.MaximalGapLength = 3; % To try to save frame gaps in which the particle wasn't visible within the range given by MaximalVelocity

AnalysisFile = 'ParticleList';
PrecissionLimit = 2; %Precission to filter out particle coordinates
OverlapFrame = true;
LocationGlass = 33.5; % [µm] For absolute Z positioning, the average position of the non-moving beads is used

disp('Generating Tracks...')
% This version tries to optimize the time to calculate the tracks. If they are 
% done, it does not calculate it again. For this, use the variable Starting
% below:
Starting = 'BuildParticleList';  
close all
switch Starting
    case 'BuildParticleList'
        %% Preparing Data. Evaluating Number of tracks if we take individual planes
        Filename = 'All_1_t1-20126_Results_v010_20201125.txt';
        [T, X, Y, Z, BestPrec] = importfile();
        disp(strcat('Total Number of positions in file',num2str(length(X))));
        Positions = struct;  
        disp(strcat('Removing the elements with precission lower than:', num2str(PrecissionLimit), ' µm'));
        PointsToRemove = [];
        for I = 1:length(BestPrec)
            if BestPrec(I) >= PrecissionLimit
                PointsToRemove = [PointsToRemove I];
            end
        end       
        T(PointsToRemove) = [];
        X(PointsToRemove) = [];
        Y(PointsToRemove) = [];
        Z(PointsToRemove) = [];     
        for FrameNum = 0:max(T) %Input from the TrackMate starts from zero
            Centroids = [X(find(T==FrameNum)) Y(find(T==FrameNum)) Z(find(T==FrameNum))]'; %PixelSize is used because data in X,Y are in pixel, but Z in µm
            Positions(FrameNum+1).Centroids = Centroids;    
        end       
        [Tracks] = CalculateTracks(Settings, Positions);
        [Tracks] = OrderTracks(Tracks);
        save(AnalysisFile,'Centroids','Positions','Tracks')
        disp('GetTracks Done')
    case 'RunFromMemory'
        disp('Using Particles in memory')
    case 'LoadParticleList'               
        load(AnalysisFile)
end

%% 
disp('Evaluating the fraction of tracked points used from the tracked data')
TotalNumberTracks = length(Tracks)
LengthTracks = zeros(1,TotalNumberTracks);
MaxFrames = 0;
for I = 1:TotalNumberTracks
    LengthTracks(I) = sum(~isnan(Tracks(I).Track(1,:)));
end
disp(strcat('Total Number of Positions Used', num2str(sum(LengthTracks))));

%% Displaying overview
MaxTime = 20000; % using round number of time points for displaying
disp(strcat('Duration:',num2str(MaxTime),'--Frames'))
disp(strcat('Duration:',num2str(MaxTime/500),'--Seconds'))
TracksDisplayed = 1000; % Selecting the maximal number of particles displayed
disp(strcat('Drawing ', num2str(TracksDisplayed), 'Tracks'))
figure
PlotTrack(Tracks(:,1:TracksDisplayed),Settings.PixelSize, MaxTime, OverlapFrame, LocationGlass);
drawnow
set(gcf,'WindowState','maximized')
%% Displaying individual cases
Range = 1:10;
PlotIndividualTracks(Tracks,Settings.PixelSize, MaxTime, false, Range, LocationGlass);
PlotColorbar('Time (s)', 40)
beep

%% Function to plot the trajectories of all particles
function PlotTrack(Tracks,PixelSize,MaxFrames, OverlapFrame, LocationGlass)
    TotalNumberTracks = length(Tracks);
    %% Plotting tracks
    Displacement = 20/PixelSize; % Arrow length after conversion from µm in pixels
    PIn = [0 165 LocationGlass-Displacement];
    ArrowColor = [0 0.3 0.6];
    colormap jet;
    Col = colormap;

    if OverlapFrame
        Background = double(imread('BackgroundCell.png'));
        Background = Background - min(min(Background));
        Background = max(max(Background)) - Background; %Inverting the image
        imsurf(Background,[0 0 LocationGlass],[0 0 -1],[1 0 0], 11/32)
        colormap gray
        hold on
    end
    
    Coloring = 'Lines'; % alternatives Spheres or Lines
    stemWidth = 0.5;
    tipWidth = 1;
    ColExtended = interp1(1:(MaxFrames/size(Col,1)):MaxFrames,Col,1:MaxFrames,'linear','extrap');
    mArrow3(PIn,PIn + [0 -Displacement 0],'color',ArrowColor,'stemWidth',stemWidth,'tipWidth',tipWidth,'FaceLighting','gouraud','SpecularExponent',1);
    hold all
    mArrow3(PIn,PIn + [0 0 Displacement],'color',ArrowColor,'stemWidth',stemWidth,'tipWidth',tipWidth,'FaceLighting','gouraud','SpecularExponent',1);
    mArrow3(PIn,PIn + [Displacement 0 0],'color',ArrowColor,'stemWidth',stemWidth,'tipWidth',tipWidth,'FaceLighting','gouraud','SpecularExponent',1);
    text(PIn(1),PIn(2)-Displacement/3,PIn(3),'20 µm','FontSize',25)

    for ID = 1:TotalNumberTracks
        CurrentTrack = Tracks(ID).Track';
        switch Coloring
            case 'Lines'
                plot3(CurrentTrack(:,1),CurrentTrack(:,2),CurrentTrack(:,3),'LineWidth',1.5);%,'Color',ColContrast(ID,:))
                hold all
                plot3(CurrentTrack(:,1),CurrentTrack(:,2),LocationGlass*ones(size(CurrentTrack(:,3))),'k','LineWidth',1); % Shadow
            case 'TimeLines'
                StartData = find(~isnan(CurrentTrack(:,1)),1,'first');
                EndData = find(~isnan(CurrentTrack(:,1)),1,'last');
                hold all
                for I = StartData+1:EndData
                    plot3(CurrentTrack(I-1:I,1),CurrentTrack(I-1:I,2),CurrentTrack(I-1:I,3),'Color',ColExtended(I-1,:),'LineWidth',1.5);
                end
                plot3(CurrentTrack(:,1),CurrentTrack(:,2),LocationGlass*ones(size(CurrentTrack(:,3))),'k','LineWidth',1.5); % Shadow
        end    
    end

    axis equal
    view (-17,31)
    box on
    axis tight
    set(gca,'FontSize',20, 'ZDir','reverse');
    set(gca,'xtick',[],'ytick',[],'ztick',[]);
    AxisSetting = get(gca);
    XLIM = AxisSetting.XLim;
    YLIM = AxisSetting.YLim;
    ZLIM = AxisSetting.ZLim;
    patch([XLIM(1) XLIM(2) XLIM(2) XLIM(1)], [YLIM(2) YLIM(2) YLIM(2) YLIM(2)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','none');
    patch([XLIM(2) XLIM(2) XLIM(2) XLIM(2)], [YLIM(1) YLIM(2) YLIM(2) YLIM(1)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','none');    
    return
end

%% Function to plot the trajectories of all particles

function PlotIndividualTracks(Tracks,PixelSize, MaxFrames, OverlapFrame, Range, LocationGlass)
    figure
    %% Plotting tracks
    Displacement = 10/PixelSize; % Arrow length after conversion from µm in pixels
    ArrowColor = [0 0.3 0.6];
    colormap jet;
    Col = colormap;

    if OverlapFrame
        Background = double(imread('BackgroundCell.png'));
        Background = Background - min(min(Background));
        Background = max(max(Background)) - Background; %Inverting the image
        imsurf(Background,[0 0 LocationGlass],[0 0 -1],[1 0 0], 11/32)
        colormap gray
        hold on
    end
    
    Coloring = 'TimeLines'; % alternatives Spheres or Lines
    stemWidth = 0.3;
    tipWidth = 0.6;
    ColExtended = interp1(1:(MaxFrames/size(Col,1)):MaxFrames,Col,1:MaxFrames,'linear','extrap');
            
    for ID = Range%1:TotalNumberTracks
        figure
        CurrentTrack = Tracks(ID).Track';
        switch Coloring
            case 'Lines'
                plot3(CurrentTrack(:,1),CurrentTrack(:,2),CurrentTrack(:,3),'LineWidth',1.5);%,'Color',ColContrast(ID,:))
                hold all
                plot3(CurrentTrack(:,1),CurrentTrack(:,2),LocationGlass*ones(size(CurrentTrack(:,3))),'k','LineWidth',1); % Shadow
            case 'TimeLines'
                StartData = find(~isnan(CurrentTrack(:,1)),1,'first');
                EndData = min(MaxFrames, find(~isnan(CurrentTrack(:,1)),1,'last'));
                hold all
                for I = StartData+1:EndData
                    plot3(CurrentTrack(I-1:I,1),CurrentTrack(I-1:I,2),CurrentTrack(I-1:I,3),'Color',ColExtended(I-1,:),'LineWidth',1);
                end
                plot3(CurrentTrack(:,1),CurrentTrack(:,2),LocationGlass*ones(size(CurrentTrack(:,3))),'k','LineWidth',1.5); % Shadow
        end
       
        axis equal
        box on 
        axis tight
        title(strcat('ID track:', num2str(ID)))
        set(gca,'FontSize',20, 'ZDir','reverse');
        view (-17,31)
        box on
        AxisSetting = get(gca);
        XLIM = AxisSetting.XLim;
        YLIM = AxisSetting.YLim;
        ZLIM = AxisSetting.ZLim;
        PIn = [XLIM(1) YLIM(2) 20];
        mArrow3(PIn,PIn + [0 -Displacement 0],'color',ArrowColor,'stemWidth',stemWidth,'tipWidth',tipWidth,'FaceLighting','gouraud','SpecularExponent',1);
        hold all
        mArrow3(PIn,PIn + [0 0 Displacement],'color',ArrowColor,'stemWidth',stemWidth,'tipWidth',tipWidth,'FaceLighting','gouraud','SpecularExponent',1);
        mArrow3(PIn,PIn + [Displacement 0 0],'color',ArrowColor,'stemWidth',stemWidth,'tipWidth',tipWidth,'FaceLighting','gouraud','SpecularExponent',1);
        text(PIn(1),PIn(2)-Displacement/3,PIn(3),'10 µm','FontSize',25)
        AxisSetting = get(gca);
        XLIM = AxisSetting.XLim;
        YLIM = AxisSetting.YLim;
        ZLIM = AxisSetting.ZLim;
        patch([XLIM(1) XLIM(2) XLIM(2) XLIM(1)], [YLIM(2) YLIM(2) YLIM(2) YLIM(2)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','none');
        patch([XLIM(2) XLIM(2) XLIM(2) XLIM(2)], [YLIM(1) YLIM(2) YLIM(2) YLIM(1)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','none');    
        set(gca,'FontSize',20, 'ZDir','reverse');
        set(gca,'xtick',[],'ytick',[],'ztick',[]);
        set(gcf,'WindowState','maximized')
        drawnow
        hold off
    end    
    return
end
    
function [TracksOut] = OrderTracks(TracksIn)
    TotalNumberTracks = length(TracksIn);
    TracksOut = struct;
    LengthTracks = zeros(1,TotalNumberTracks);
    for I = 1:TotalNumberTracks
        LengthTracks(I) = sum(~isnan(TracksIn(I).Track(1,:)));
    end
    [~,Order] = sort(LengthTracks,'descend');
    for I = 1:TotalNumberTracks        
        TracksOut(I).Track = TracksIn(Order(I)).Track;
    end
return
end

function PlotColorbar(Label, MaxTime)
    FigColorbar = figure;
    colormap jet
    c = ColorBarSet(Label,[0 MaxTime]); % Consider using fprintf('%g\n', round(duration,1));
    c.FontSize = 20;
    c.Location = 'southoutside';
    close (FigColorbar)
end

function [T, X, Y, Z, BestPrec] = importfile()
%% Input handling
dataLines = [2, Inf];
%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 26);
% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = "\t";
% Specify column names and types
opts.VariableNames = ["Var1", "T", "Xum", "Yum", "Var5", "Var6", "Var7", "Zfromprecisestplaneum", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "BestPrec"];
opts.SelectedVariableNames = ["T", "Xum", "Yum", "Zfromprecisestplaneum", "BestPrec"];
opts.VariableTypes = ["string", "double", "double", "double", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double"];
% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var5", "Var6", "Var7", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var5", "Var6", "Var7", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25"], "EmptyFieldRule", "auto");
% Import the data
tbl = readtable('All_1_t1-20126_Results_v010_20201125.txt', opts);
%% Convert to output type
T = tbl.T;
X = tbl.Xum;
Y = tbl.Yum;
Z = tbl.Zfromprecisestplaneum;
BestPrec = tbl.BestPrec;
end