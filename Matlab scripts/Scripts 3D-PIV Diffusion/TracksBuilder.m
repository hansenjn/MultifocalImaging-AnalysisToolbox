
%% The following program attempts to improve the tracking. It connects tracks where the particle was not successfully detected in all consecutive frames 
function TracksBuilder
    %% Acquisition and track detection settings
    Settings = struct;
    Settings.PixelSize = 1; % in µm per pixel. Conversion not needed for this data, as the positions are already in µm
    Settings.AcquisitionRate = 250; % Frames per second
    Settings.MaxVelocity = 150;% Filter for the particle velocity in µm per s
    Settings.MinTrackDuration = 250; % Filter to remove small tracks (in Frames)
    Settings.MinTrackExtension = 1; % Filter to remove short tracks (usually particles sticking to the surface) (in µm)
    Settings.MaximalGapLength = 3; % Maximal number of consecutive frames with no particle detected where the program still attempts to extend the track
    Settings.InterpolateGaps = false; % Boolean determining whether gaps are interpolated or left as NaN

    % loading Data
    FileName1 = '1_IcSpR_All_Cr_MAX_SpotsTM_xy_CMFPT_10_10_s.txt';
    [X1, Y1, Z1, T1, ZPrecision1] = GetCoordinates(FileName1);
    FileName2 = '2_IcSpR_All_Cr_MAX_SpotsTM_xy_CMFPT_10_10_s.txt';
    [X2, Y2, Z2, T2, ZPrecision2] = GetCoordinates(FileName2);
    FileName3 = '3_IcSpR_All_Cr_MAX_SpotsTM_xy_CMFPT_10_10_s.txt';
    [X3, Y3, Z3, T3, ZPrecision3] = GetCoordinates(FileName3);
    FileName4 = '4_IcSpR_All_Cr_MAX_SpotsTM_xy_CMFPT_10_10_s.txt';
    [X4, Y4, Z4, T4, ZPrecision4] = GetCoordinates(FileName4);
    
    %Joining recordings
    X = [X1; X2; X3; X4];
    Y = [Y1; Y2; Y3; Y4];
    Z = [Z1; Z2; Z3; Z4];
    T = [T1; T2; T3; T4];
    Zprecision = [ZPrecision1; ZPrecision2; ZPrecision3; ZPrecision4];
   
    disp('Mean z precision ALL:')
    mean(Zprecision)
    disp('sd z precision:')
    std(Zprecision) 
    disp('....')
    
    %% Preparing data as a structure 'Positions'. This structure contains a list of coordinates for each frame including all detected particles.
    Positions = struct;  
    for FrameNum = 0:max(T) %Input from the TrackMate starts from zero
        %Collecting all particles detected in a particular frame
        Row = find(T==FrameNum);
        Centroids = [X(Row) Y(Row) Z(Row)]';
        Positions(FrameNum+1).Centroids = Centroids;    
    end
    %% Generating tracks 
    disp('Calculating tracks from detected particle positions')
    [Tracks] = CalculateTracks(Settings, Positions); 
    save('Tracks', 'Tracks');
    %% Plotting tracks
    disp('Plotting tracks')
    PlotTracksBeads(Tracks, 'TimeLines', Settings); % for speed, you can replace 'TimeLines' for 'Lines'
    disp('Done');
end

function [X, Y, Z, T, Zprecision] = GetCoordinates(FileName)
    %% Reading text file with tracked centroids  
    % replacing, eventually, commas for dots
    Data = fileread(FileName);
    Data = strrep(Data, ',', '.');
    OutputFile = strcat('Dots_', FileName(1:end-4), '.txt');
    FileHandle = fopen(OutputFile, 'w');
    fwrite(FileHandle, Data, 'char');
    fclose(FileHandle);
    Data = readmatrix(OutputFile);
    Z = Data(:,8);
    BadPoints = isnan(Z);
    Z = Z(~BadPoints);
    T = Data(~BadPoints,2);
    X = Data(~BadPoints,3);
    Y = Data(~BadPoints,4);
    Zp1 = Data(~BadPoints,end-4);
    Zp2 = Data(~BadPoints,end-3);
    Zp3 = Data(~BadPoints,end-2);
    Zp4 = Data(~BadPoints,end-1);
    Zprecision = min(Zp1, Zp2,'omitnan');
    Zprecision = min(Zprecision, Zp3,'omitnan');
    Zprecision = min(Zprecision, Zp4,'omitnan');
    disp('Mean z precision:')
    mean(Zprecision)
    return
end

function [Tracks] = CalculateTracks(Settings, Positions)
% Identifies particles and joints their position in time to generate tracks
% Particles are joint across frames by their proximity in space. As soon as
% one position at any time point is included into a track, 
% this position is removed form the Positions.Centroids pool until the pool
% is empty. If a gap is found, the program might attempt to extend the
% track using particles found ahead in time. 
Dimensions = size(Positions(1).Centroids(:,1),1); % for 2 and 3D
if Dimensions < 2 || Dimensions > 3
    disp('ERROR ONLY WORKS FOR 2 or 3 DIMENSIONS!')
end
ParticleID = 0;
Tracks = struct;
MaxVelocityMovie = Settings.MaxVelocity/(Settings.AcquisitionRate*Settings.PixelSize); % Translation from µm/s to pixels/frame
MaxVelocitySquare = MaxVelocityMovie^2;
nFrames = length(Positions);

for FrameNum = 1:nFrames-1
    for CentroidNum = 1:size(Positions(FrameNum).Centroids,2) % Looking for one particle that has not yet been used in a track
        ParticleID = ParticleID +1;
        FramesRescueUsed = 0; % Counter for gap length
        AccumulatedMaxVelocitySquare = MaxVelocitySquare; % Square of the search radius for particles
        CurrentTrack = NaN(Dimensions,nFrames); % allocating memory for the track. All tracks have the same length equal to the movie length
        % this uses unnecessary memory resources, but allows to easilly
        % locate their appeareance in time and facilitates the code for
        % plotting later. Before appearance, the coordiantes will be NaN
        CurrentTrack(:,FrameNum) = Positions(FrameNum).Centroids(:,CentroidNum); %Picking up one of the available centroids at this time point
        YetAnotherPointMightCome = true; % Flag to identify when there potentially exist more points to join to the track
        FutureFrame = FrameNum;
        % at this point, points are joint to the track and removed from the
        % pool
        while YetAnotherPointMightCome
            FutureFrame = FutureFrame + 1;
            A = Positions(FutureFrame).Centroids; % A will contain all the available centroids in the next frame
            NumAvailableCentroids = size(A,2);
            if ~isempty(A) % if not all positions have been already taken
                B = CurrentTrack(:,FutureFrame-1-FramesRescueUsed); % Last tracked position for the particle
                C = repmat(B,1,NumAvailableCentroids); % Matrix repetition of B to calculate in a single shot all distances to all other centroids
                Distances = double((A - C).*(A - C)); 
                DistancesSquare = sum(Distances);
                [DistanceSquaredToNearest,Index] =  min(DistancesSquare); % Locating the particle nearest to the previous position
                if DistanceSquaredToNearest < AccumulatedMaxVelocitySquare 
                    CurrentTrack(:,FutureFrame) = Positions(FutureFrame).Centroids(:,Index);
                    Positions(FutureFrame).Centroids(:,Index) = []; %Remove that position from the list
                    FramesRescueUsed = 0;
                    AccumulatedMaxVelocitySquare = MaxVelocitySquare;
                else
                    CurrentTrack(:,FutureFrame) = nan*CurrentTrack(:,FutureFrame-1); %% particle not detected. It will be attempted to be found on next iteration
                    FramesRescueUsed = FramesRescueUsed + 1;
                    AccumulatedMaxVelocitySquare = double(2*AccumulatedMaxVelocitySquare); %time is doubled
                end
            end
            if   FutureFrame == nFrames || isempty(A) || FramesRescueUsed >= Settings.MaximalGapLength
                 YetAnotherPointMightCome = false;
            end
        end

%% Filtering Short Tracks
        [FrameNumber,~] = NoNaN(CurrentTrack(1,:));
        Loc = ~isnan(CurrentTrack);
        TrackVector1 = CurrentTrack(:,find(Loc(1,:),1,'first'));
        TrackVector2 = CurrentTrack(:,find(Loc(1,:),1,'last'));
        if ~isempty(TrackVector1)            
            T1 = TrackVector1;
            T2 = TrackVector2;
            T1(3) = 0;
            T2(3) = 0;
            d = pdist([T1'; T2'],'euclidean');
        else
            d = 0;
        end
        if length(FrameNumber) < Settings.MinTrackDuration || (d<Settings.MinTrackExtension) %Here can be changed for the euclidean distance or for the xy plane
            ParticleID = ParticleID - 1;
        else
            if Settings.InterpolateGaps
                for Dim = 1:Dimensions
                    [FrameNumberInterp,NoNaNValues] = NoNaN(CurrentTrack(Dim,:));
                    CurrentTrack(Dim,FrameNumberInterp(1):FrameNumberInterp(end)) = interp1(FrameNumberInterp,NoNaNValues,FrameNumberInterp(1):FrameNumberInterp(end),'linear');                   
                end
            end
            Tracks(ParticleID).Track = CurrentTrack;
        end
    end
end
end

function PlotTracksBeads(Tracks, Coloring, Settings)
% Coloring is used for different display options. It can be 'Lines', then a
% tracks will be plotted using a single color or 'TimeLines'. The latter
% makes plots where time is color coded, but takes much longer.
%% Stablishing range for display
MinX = Inf;
MaxX = -Inf;
MinY = Inf;
MaxY = -Inf;
MinZ = Inf;
MaxZ = -Inf;
TotalNumberTracks = length(Tracks)
for ID = 1:TotalNumberTracks 
    CurrentTrack = Tracks(ID).Track';
    MinX = min(min(CurrentTrack(:,1),[],'omitnan'),MinX);
    MinY = min(min(CurrentTrack(:,2),[],'omitnan'),MinY);
    MinZ = min(min(CurrentTrack(:,3),[],'omitnan'),MinZ);
    MaxX = max(max(CurrentTrack(:,1),[],'omitnan'),MaxX);
    MaxY = max(max(CurrentTrack(:,2),[],'omitnan'),MaxY);
    MaxZ = max(max(CurrentTrack(:,3),[],'omitnan'),MaxZ);
end
%% Shifting Z to show shadows
ShiftZ = 0.2;
for ID = 1:TotalNumberTracks
    CurrentTrack = Tracks(ID).Track;
    CurrentTrack(3,:) = CurrentTrack(3,:) - MinZ + ShiftZ;
    Tracks(ID).Track = CurrentTrack;
end

%% Plotting tracks
colormap jet;
Col = colormap;
ColExtended = InterpolatedColormap(Col,length(CurrentTrack));
CaseDisplay = 1:TotalNumberTracks;
hold all

% Plotting a vector triad as dimension reference 
Origin = [MinX-1 MinY-1 0.5]; 
LengthVector = 10; % Arrow length in µm
mArrow3(Origin,Origin + [0 LengthVector 0],'color','blue','stemWidth',0.4,'tipWidth',0.8,'FaceLighting','gouraud','SpecularExponent',1);
mArrow3(Origin,Origin + [0 0 LengthVector],'color','red','stemWidth',0.4,'tipWidth',0.8,'FaceLighting','gouraud','SpecularExponent',1);
mArrow3(Origin,Origin + [LengthVector 0 0],'color','green','stemWidth',0.4,'tipWidth',0.8,'FaceLighting','gouraud','SpecularExponent',1);

TimeStep = 1;
Counter = 0;
for ID = CaseDisplay   
    Counter = Counter + 1;
    CurrentTrack = Tracks(ID).Track';
    FirstTimePoint = find(~isnan(CurrentTrack(:,1)),1,'first');
    LastTimePoint = find(~isnan(CurrentTrack(:,1)),1,'last');
    Range = FirstTimePoint:LastTimePoint-1;
    RangeShort = FirstTimePoint:TimeStep:LastTimePoint-1;
    switch Coloring
        case 'Lines'
            plot3(CurrentTrack(Range,1),CurrentTrack(Range,2),CurrentTrack(Range,3),'LineWidth',1.5)
            hold all
            plot3(CurrentTrack(Range,1),CurrentTrack(Range,2),zeros(size(CurrentTrack(Range,3))),'k','LineWidth',1)
        case 'TimeLines'        
            hold all
            for Index = RangeShort%length(CurrentTrack)-1     
                plot3(CurrentTrack(Index:Index+1,1),CurrentTrack(Index:Index+1,2),CurrentTrack(Index:Index+1,3),'Color',ColExtended(Index,:),'LineWidth',1);
            end
            plot3(CurrentTrack(RangeShort,1),CurrentTrack(RangeShort,2),zeros(size(CurrentTrack(RangeShort,3))),'k','LineWidth',1); % Shadow
    end
end

light ('Position',[-0.0735 -0.0090 1.4123])
axis equal
gcf.WindowState = 'maximized';
axis tight
box on
set(gca,'FontSize',20);    
set(gca,'XTick',[],'Ytick',[], 'ZTick',[])    
view(-20,16)
set(gca,'Projection','orthographic')
if strcmp(Coloring,'TimeLines')
    colormap jet
    ColorBar('Time (s)',[0 length(CurrentTrack)/Settings.AcquisitionRate],'FontSize',16,'Location','south');
end
AxisSetting = get(gca);
XLIM = AxisSetting.XLim;
YLIM = AxisSetting.YLim;
ZLIM = AxisSetting.ZLim;
patch([XLIM(2) XLIM(1) XLIM(1) XLIM(2)], [YLIM(2) YLIM(2) YLIM(2) YLIM(2)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','gouraud');
patch([XLIM(2) XLIM(2) XLIM(2) XLIM(2)], [YLIM(1) YLIM(2) YLIM(2) YLIM(1)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','gouraud');
drawnow
disp('Saving figures');
savefig(gcf,'GlobalView.fig');
saveas(gcf,'GlobalView.png');
return
end

function h = ColorBar(Label,TickValues,varargin)
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


function ColorMapOut = InterpolatedColormap(ColormapIn,NumberPoints)
    %Function returns an interpolated colormap that contains as many
    %elements as requested
      
    Step = (NumberPoints-1)/(length(ColormapIn)-1);
    R = interp1(1:length(ColormapIn),ColormapIn(:,1),1:1/Step:length(ColormapIn));
    G = interp1(1:length(ColormapIn),ColormapIn(:,2),1:1/Step:length(ColormapIn));
    B = interp1(1:length(ColormapIn),ColormapIn(:,3),1:1/Step:length(ColormapIn));
    ColorMapOut = [R' G' B'];

return
end
