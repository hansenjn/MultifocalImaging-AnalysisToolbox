% Program displaying a back view on a specific point along the flagellum to
% visualize cell rolling
%% Loading data
XFile = '20160928_human_n3_f5_cr_icorr_-MEDI_spr_mfa_200820_185410_coordX.txt';
YFile = '20160928_human_n3_f5_cr_icorr_-MEDI_spr_mfa_200820_185410_coordY.txt';
ZFile = '20160928_human_n3_f5_cr_icorr_-MEDI_spr_mfa_200820_185410_coordZ.txt';
X_All = ImportData(XFile);
Y_All = ImportData(YFile);
Z_All = ImportData(ZFile);
PreciseRegion = 10:92;%Region with good z precision corresponding to 5-50 µm
Resolution = double(1); %Only needed if coordinates are not provided in µm

%% Plot colorbar
PlotColorbar('BackView', 'Time (ms)', 150)
Origin = [-7 4];
Draft = false;
close all
% Plotting the view from the back at different time points
for Start = 1:50:400
    Frame = Start:Start + 75;
    X = X_All(Frame,:);
    Y = Y_All(Frame,:);
    Z = Z_All(Frame,:);
    X(:,PreciseRegion(end)+1:end) = [];
    Y(:,PreciseRegion(end)+1:end) = [];
    Z(:,PreciseRegion(end)+1:end) = [];

    % Removing the mean
    Z = Z - mean(mean(Z,'omitnan'),'omitnan');
    X = X - mean(mean(X,'omitnan'),'omitnan');
    Y = Y - mean(mean(Y,'omitnan'),'omitnan');

    % Scaling to µm
    Z = Z'/Resolution;
    X = X'/Resolution;
    Y = Y'/Resolution;

   [b,p,e,vb,vp,ve,lamda] = Gyration_Tensor2(X',Y',Z'); 
    mean_ve = mean(ve,1,'omitnan');
    if sum(mean_ve) > 0
        mean_ve = -mean_ve;
    end
    % Rotating the data so, that the vector b is pointing towards x positive
    [Tetha_ve, ~] = cart2pol(mean_ve(1),mean_ve(2));
    for I = 1:size(X,2)
        [Tetha_flagellum, Rho_flagellum] = cart2pol(X(:,I),Y(:,I));
        Tetha_flagellum = Tetha_flagellum - Tetha_ve;
        [X(:,I), Y(:,I)] = pol2cart(Tetha_flagellum, Rho_flagellum);
    end

    %% Determine the range for the plots
    XMin = min(min(X));
    YMin = min(min(Y));
    XMax = max(max(X));
    YMax = max(max(Y));
    ZMax = max(max(Z));
    ZMin = min(min(Z));

    %% Shifting flagella to origin
    Shift = 2; % in µm
    Z = Z - ZMin + Shift;

    %% Plot 
    FigHand =  figure;
    colormap jet;
    Col = colormap;
    FigHand.WindowState = 'maximized';
    set(FigHand,'Renderer','opengl','Color',[1 1 1]);
    opengl ('software') % This is to avoid some bug that occurs when capturing the screen with getframe
    light('Style','infinite');

    flagellarPos = 60;
    ColorFactor = 256/length(Frame);

    hold on
    [NoNaNArrayPos, NoNaNArrayX] = NoNaN(1:length(Frame), X(flagellarPos,:));
    X(flagellarPos, :) = interp1(NoNaNArrayPos, NoNaNArrayX, 1:length(Frame));
    [NoNaNArrayPos, NoNaNArrayY] = NoNaN(1:length(Frame), Y(flagellarPos,:));
    Y(flagellarPos, :) = interp1(NoNaNArrayPos, NoNaNArrayY, 1:length(Frame));
    [NoNaNArrayPos, NoNaNArrayZ] = NoNaN(1:length(Frame), Z(flagellarPos,:));
    Z(flagellarPos, :) = interp1(NoNaNArrayPos, NoNaNArrayZ, 1:length(Frame));
    % smoothing data
    Z(flagellarPos, :) = powersmooth(Z(flagellarPos, :),1,1,'Normal');
    Y(flagellarPos, :) = powersmooth(Y(flagellarPos, :),1,1,'Normal');
    X(flagellarPos, :) = powersmooth(X(flagellarPos, :),1,1,'Normal');
    for FrameNumber =  2:length(Frame)
        plot([Y(flagellarPos,FrameNumber) Y(flagellarPos, FrameNumber-1)], [Z(flagellarPos,FrameNumber) Z(flagellarPos,FrameNumber-1)], 'Color', Col(ceil(ColorFactor*FrameNumber),:), 'LineWidth', 1.5)  
    end
    plot(Origin(1) + [0 2], Origin(2) + [0 0], 'k', 'LineWidth',4)
    LocationReference = Origin + [1 0];
    text(LocationReference(1)-0.15,LocationReference(2)-0.4,'Y','FontSize',16)
    plot(Origin(1) + [0 0], Origin(2) + [0 2], 'k', 'LineWidth',4)
    LocationReference = Origin + [0 1];
    text(LocationReference(1)-0.5,LocationReference(2),'Z','FontSize',16)
    
    set(gca,'FontSize',16)
    axis equal
    if Draft
        xlabel('Y')
        ylabel('Z')
        title(num2str(Start))
    else
        axis off
        orient(gcf,'landscape')
        set(gcf,'PaperType','A3')
        %exportgraphics(gca, 'HumanSperm_BackView.pdf', 'ContentType', 'vector')  
        exportgraphics(gca, 'HumanSperm_BackView.png', 'ContentType', 'image', 'Resolution', 300)  
    end    
end


function PlotColorbar(FileName, Label, MaxTime)
    FigColorbar = figure;
    colormap jet
    c = ColorBarSet(Label,[0 MaxTime]);
    c.FontSize = 20;
    c.Location = 'southoutside';
    orient(FigColorbar,'landscape')
    set(FigColorbar,'PaperType','A3')
    exportgraphics(gca, strcat(FileName, '_Colorbar.pdf'), 'ContentType', 'vector')  
    close (FigColorbar)
end