%% Defining plot region
LocationReferenceArrow = [25 -25 0];
Draft = false;
Start = 1;
Step = 4;
Frame = Start:Step:500;

%% Loading data
XFile = '1_All_IcSpR_BCr_mfa_200902_103555_coordX.txt';
YFile = '1_All_IcSpR_BCr_mfa_200902_103555_coordY.txt';
ZFile = '1_All_IcSpR_BCr_mfa_200902_103555_coordZ.txt';
X = ImportData(XFile);
Y = ImportData(YFile);
Z = ImportData(ZFile);
PreciseRegion = 16:132;%Region with good z precision corresponding to 5-45 �m
Resolution = double(1); %Only needed if coordinates are not provided in �m
disp(strcat('Max number frames = ', num2str(length(X))))
X(:,PreciseRegion(end)+1:end) = [];
Y(:,PreciseRegion(end)+1:end) = [];
Z(:,PreciseRegion(end)+1:end) = [];
X(Frame(end)+1:end,:) = [];
Y(Frame(end)+1:end,:) = [];
Z(Frame(end)+1:end,:) = [];
if Start>1
    X(1:Start-1,:) = [];
    Y(1:Start-1,:) = [];
    Z(1:Start-1,:) = [];
end
% Removing the mean. 
Z = Z - mean(mean(Z,'omitnan'),'omitnan');
X = X - mean(mean(X,'omitnan'),'omitnan');
Y = Y - mean(mean(Y,'omitnan'),'omitnan');
% Scaling to �m
Z = Z'/Resolution;
X = X'/Resolution;
Y = Y'/Resolution;

%% Plot colorbar
PlotColorbar('SeaUrchinGlobalView', 'Time (s)', 1)

%% The following is done to rotate the data as to align itwith the X axis for the plots. Only for aesthetics
[b,p,e,vb,vp,ve,lamda] = Gyration_Tensor2(X',Y',Z'); 
mean_ve = mean(ve,1,'omitnan');
if sum(mean_ve) < 0
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
Shift = 2; % in �m
Z = Z - ZMin + Shift;

%% Plot 
close all
FigHand =  figure;
set(FigHand,'Renderer','opengl','Color',[1 1 1]);
opengl ('software') % This is to avoid some bug that occurs when capturing the screen with getframe
colormap jet;
Col = colormap;
ColorFactor = 255/(length(Frame)*Step);
for FrameNumber =  Frame
    [~,XOut] = NoNaN(X(:,FrameNumber-Start+1));
    [~,YOut] = NoNaN(Y(:,FrameNumber-Start+1));
    [~,ZOut] = NoNaN(Z(:,FrameNumber-Start+1));   
    plot3(XOut,YOut,ZOut,'Color',Col(ceil(ColorFactor*(FrameNumber-Start)+1),:),'LineWidth',1.5);
    hold on
    plot3(XOut,YOut,zeros(size(ZOut)),'Color',0*[1 1 1],'LineWidth',1.5);
    drawnow
    axis  equal;
end

view(128,20);
box on
Size = 10; % Size arrow in �m
Thinning = 0.5;
ArrowColor = [0 0.3 0.6];
mArrow3(LocationReferenceArrow,LocationReferenceArrow + Size*[-1 0 0],'color',ArrowColor,'tipWidth',1*Resolution*Thinning,'stemWidth',0.5*Resolution*Thinning);
mArrow3(LocationReferenceArrow,LocationReferenceArrow + Size*[0 1 0],'color',ArrowColor,'tipWidth',1*Resolution*Thinning,'stemWidth',0.5*Resolution*Thinning);
mArrow3(LocationReferenceArrow,LocationReferenceArrow + Size*[0 0 1],'color',ArrowColor,'tipWidth',1*Resolution*Thinning,'stemWidth',0.5*Resolution*Thinning);
text(LocationReferenceArrow(1),LocationReferenceArrow(2)+1.5,LocationReferenceArrow(3)+2.7,'10 �m','Rotation',90,'FontSize',24)
set(gca,'Projection','Perspective')

AxisSetting = get(gca);
XLIM = AxisSetting.XLim;
YLIM = AxisSetting.YLim;
ZLIM = AxisSetting.ZLim;
patch([XLIM(1) XLIM(2) XLIM(2) XLIM(1)], [YLIM(1) YLIM(1) YLIM(1) YLIM(1)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','none');
patch([XLIM(1) XLIM(1) XLIM(1) XLIM(1)], [YLIM(1) YLIM(2) YLIM(2) YLIM(1)],[ZLIM(1) ZLIM(1) ZLIM(2) ZLIM(2)],[0.8 0.8 0.8],'FaceLighting','none');

FigHand.WindowState = 'maximized';
if Draft
    xlabel('X')
    ylabel('Y')
else
    set(gca,'xtick',[],'ytick',[],'ztick',[]);
    light('Style','infinite');
    MyLight = light;
    set(MyLight, 'Position', [-0.6848 0.0720 1.0603]);
    exportgraphics(gca, 'SeaUrchin_GlobalView.png', 'ContentType', 'image', 'Resolution', 300)  
end

function PlotColorbar(FileName, Label, MaxTime)
    FigColorbar = figure;
    colormap jet
    c = ColorBarSet(Label,[0 MaxTime]);
    c.FontSize = 20;
    c.Location = 'southoutside';
    orient(FigColorbar,'landscape')
    set(FigColorbar,'PaperType','A3')
    exportgraphics(gca, strcat(FileName(1:end-4), '_Global_Colorbar.pdf'), 'ContentType', 'vector')  
    close (FigColorbar)
end