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