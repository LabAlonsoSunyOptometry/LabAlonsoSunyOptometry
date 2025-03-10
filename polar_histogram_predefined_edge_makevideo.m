function hpol = polar_histogram_predefined_edge_makevideo(theta,rho,rho_max,line_style,line_color)
%POLAR  Polar coordinate plot.
%   POLAR(THETA, RHO) makes a plot using polar coordinates of
%   the angle THETA, in radians, versus the radius RHO.
%   POLAR(THETA,RHO,S) uses the linestyle specified in string S.
%   See PLOT for a description of legal linestyles.
%
%
%
%   Example:
%      t = 0:.01:2*pi;
%      polar_histogram_mine(t,sin(2*t).*cos(2*t),'--',[180 0 180]/255)
%

%   Copyright 1984-2006 The MathWorks, Inc.
%   $Revision: 5.22.4.7 $  $Date: 2006/05/27 18:07:42 $



cax = []; 
% get hold state
cax = newplot(cax);
    
ax = gca;
get( ax );
set( ax, 'Color', [0.7,0.7,0.7] )


next = lower(get(cax,'NextPlot'));
hold_state = ishold(cax);
%hold_state = 1; 

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
% fAngle  = get(cax, 'DefaultTextFontAngle');
% %fName   = get(cax, 'DefaultTextFontName');
% fSize   = get(cax, 'DefaultTextFontSize');
% fWeight = get(cax, 'DefaultTextFontWeight');
% fUnits  = get(cax, 'DefaultTextUnits');
% set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
%     'DefaultTextFontName',   get(cax, 'FontName'), ...
%     'DefaultTextFontSize',   get(cax, 'FontSize'), ...
%     'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
%     'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state

% make a radial grid
    hold(cax,'on');
    %maxrho = max(abs(rho(:)));
    maxrho = .4;%1 : r_max 
    hhh=line([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho],'parent',cax);
    set(cax,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
    v = [get(cax,'xlim') get(cax,'ylim')];
    ticks = sum(get(cax,'ytick')>=0);
    delete(hhh);
% check radial limits and ticks
    rmin = 0;
    %rmax = v(4); 
    
    
    %************************rmax value****************
    rmax = 1.1 * rho_max; %1 : r_max 
    %**************************************************
    rticks = max(ticks-1,2);
    if rticks > 5   % see if we can reduce the number
        if rem(rticks,2) == 0
            rticks = rticks/2;
        elseif rem(rticks,3) == 0
            rticks = rticks/3;
        end
    end

% define a circle
    th = 0:pi/50:2*pi;
    xunit = cos(th);
    yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
    inds = 1:(length(th)-1)/4:length(th);
    xunit(inds(2:2:4)) = zeros(2,1);
    yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
    if ~ischar(get(cax,'color')),
       patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
             'edgecolor',tc,'facecolor',get(cax,'color'),...
             'handlevisibility','off','parent',cax);
    end

% draw radial circles
%     c82 = cos(82*pi/180);
%     s82 = sin(82*pi/180);
%     rinc = (rmax-rmin)/rticks;
%     for i=(rmin+rinc):rinc:rmax
%         hhh = line(xunit*i,yunit*i,'linestyle',ls,'color',tc,'linewidth',1,...
%                    'handlevisibility','off','parent',cax);
%         text((i+rinc/20)*c82,(i+rinc/20)*s82, ...
%             ['  ' num2str(i)],'verticalalignment','bottom',...
%             'handlevisibility','off','parent',cax)
%     end
%     set(hhh,'linestyle','-') % Make outer circle solid

% plot spokes
    th = (1:6)*2*pi/12;
    cst = cos(th); snt = sin(th);
    cs = [-cst; cst];
    sn = [-snt; snt];
    line(rmax*cs,rmax*sn,'linestyle',ls,'color',tc,'linewidth',1,...
         'handlevisibility','off','parent',cax)

% annotate spokes in degrees
    rt = 1.1*rmax;
    for i = 1:length(th)
%         text(rt*cst(i),rt*snt(i),int2str(i*30),...
%              'horizontalalignment','center',...
%              'handlevisibility','off','parent',cax);
        if i == length(th)
            loc = int2str(0);
        else
            loc = int2str(180+i*30);
        end
%         text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center',...
%              'handlevisibility','off','parent',cax)
    end

% set view to 2-D
    view(cax,2);
% set axis limits
    axis(cax,rmax*[-1 1 -1.15 1.15]);
end

% Reset defaults.
% set(cax, 'DefaultTextFontAngle', fAngle , ...
%     'DefaultTextFontName',   fName , ...
%     'DefaultTextFontSize',   fSize, ...
%     'DefaultTextFontWeight', fWeight, ...
%     'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% plot data on top of grid

q = plot(xx,yy,line_style,'Color',line_color,'parent',cax,'linewidth',2);

if nargout == 1
    hpol = q;
end

if ~hold_state
    set(cax,'dataaspectratio',[1 1 1]), axis(cax,'off'); set(cax,'NextPlot',next);
end
set(get(cax,'xlabel'),'visible','on')
set(get(cax,'ylabel'),'visible','on')

if ~isempty(q) && ~isdeployed
    makemcode('RegisterHandle',cax,'IgnoreHandle',q,'FunctionName','polar');
end