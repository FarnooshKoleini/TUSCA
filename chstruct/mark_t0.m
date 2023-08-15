function [z] = mark_t0(t,a);
% mark_t0 -- dispaly GUI for marking location of t0 for kinetic fitting.
%
% [z] = mark_t0(t,a);
%
%   z.t0, z.t0_idx, z.idx z.t, z.a returned.
%
% if user hits cancel, t = []

if nargin == 2,
    ht = figure('numbertitle','off','name','Non-linear Least-Squares Kinetic Fitting',...
        'tag','kinfit','renderer','opengl');
    set(ht,'CloseRequestFcn','kin_closereq');
    
    plot(t,a);                % plot spectra vs time
    z.t = t; z.a = a;
    set(ht,'userdata',z);     % save it in figure
    
    ht1 = uicontrol('Style', 'pushbutton', 'String', 'Cancel',...
        'Units','Normalized','Position', [.14 .93 .1 .05], 'Callback', 'mark_t0(1);');
    ht2 = uicontrol('Style', 'pushbutton', 'String', 'Mark time = 0',...
        'Units','Normalized','Position', [.25 .93 .15 .05], 'Callback', 'mark_t0(2);');
    ht3 = uicontrol('Style', 'pushbutton', 'String', 'Done',...
        'Units','Normalized','Position', [.41 .93 .1 .05], 'Callback', 'mark_t0(3);');
    ht4 = uicontrol('Style', 'text', 'String', 'Zoom feature is enabled',...
        'Units','Normalized','Position', [.53 .93 .3 .05], 'Callback', 'mark_t0(3);');
    
    zoom(ht,'reset'); % remember current zoom state
    zoom(ht,'on');
    
    uiwait(ht);
    z=get(ht,'userdata');
    z.t = t(z.t_idx) - z.t0;
    z.a = z.a(z.t_idx,:);
    delete(ht);
    
elseif t == 1;
    
    %
    % cancel kinetic fitting
    %
    kinfit = getfignum('kinfit');       % get handle to nonlin kin fit window
    z = get(kinfit,'userdata');
    z.t0 = [];
    z.t_idx = [];
    z.t0_idx = [];
    set(kinfit,'userdata',z);
    uiresume(kinfit)
    
elseif t == 2;
    
    %
    % Mark time = 0
    %
    kinfit = getfignum('kinfit');       % get handle to nonlin kin fit window
    z = get(kinfit,'userdata');         % get kinfit data structure
    t=z.t; a=z.a;
    
    if isfield(z,'handle_t0'),          % delete old marks if present
        delete(z.handle_t0)
    end

    zoom(kinfit,'off');                 % turn plot zoom off so mouse click works OK
    v=axis;
    [x,y] = ginput(1);                  % get one mouse click to mark a point
    
    [y,it]=min(abs(t-x));               % find nearest neighbor to t0 mark
    z.t0 = t(it);                         % save t0 and location of t0
    z.t0_idx = it;
    z.t_idx = it:length(t);  
    
    zoom(kinfit,'out');                 % zoom out before drawing circles
    hold on;                            % show location on plot
    z.handle_t0 = ...
        plot(t(it),a(it,:),'ro');        % mark the location in the plot w/ red circles
    hold off;
    axis(v);                            % zoom out to former zoom state
    zoom(kinfit,'on');                  % and turn zooming back on
    set(kinfit,'userdata',z);
    
elseif t == 3;
    % 
    % marking time = 0 done
    %
    kinfit = getfignum('kinfit');       % get handle to nonlin kin fit window
    z = get(kinfit,'userdata');
    if ~isfield(z,'t0');
        z.t0 = z.t(1);                         % save t0 and location of t0
        z.t0_idx = 1;
        z.t_idx = 1:length(z.t);
        set(kinfit,'userdata',z);
    end;
    uiresume(kinfit);
end;
