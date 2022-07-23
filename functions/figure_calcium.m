function [] = figure_calcium(C_1,C_2,T,dt)
% Author: Giulio Basso, 2022
% Function used for generating the calcium signals (as included in Fig. 8)
% in the paper by G. Basso, M. T. Barros,
% 'Biocomputing Model Using Tripartite Synapses Provides% Reliable Neuronal 
% Logic Gating with Spike Pattern Diversity'

% Font size
size_subtitle=40;
size_ticks=30;
size_annotation=30;
size_time_annotation=30;

%% Plot 2.5 seconds
t=(0:1:(T-1)/1.6)*dt*10^-3; % (t in seconds)

f=figure;

sub1=subplot(2,1,1);
plot(t,C_1(1:T/1.6),'m','linewidth',1.5),
hTitle = title('{\itCa^{2+} signal astrocyte 1}','FontWeight','Normal');
axis([0 t(end) min(C_1)-min(C_1)/10 max(C_1)+max(C_1)/10]);

set(sub1,'box','off',...      % remove the box (unnecessary ink)
    'tickdir','out', ...    % axis tick marks shouldn't collide with data
    'xtick',0:0.25:2.5, ...     % a denser tick spacing improves lookup possibility
    'xticklabel',{'0','','0.5','','1','','1.5','','2','','2.5'},...
    'ytick',0:0.5:1.5, ...
    'yticklabel',{'0','','1',''});

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

set(hTitle,'FontSize',size_subtitle);



sub2=subplot(2,1,2); 
plot(t,C_2(1:T/1.6),'m','linewidth',1.5),
hTitle = title('{\itCa^{2+} signal astrocyte 2}','FontWeight','Normal');
axis([0 t(end) min(C_2)-min(C_2)/10 max(C_2)+max(C_2)/10]);

% Use this axis with calcium subthreshold activity
set(sub2,'box','off',...      % remove the box (unnecessary ink)
    'tickdir','out', ...    % axis tick marks shouldn't collide with data
    'xtick',0:0.25:2.5, ...     % a denser tick spacing improves lookup possibility
    'xticklabel',{'0','','0.5','','1','','1.5','','2','','2.5'},...
    'ytick',0:0.1:0.4, ...
    'yticklabel',{'0','','0.2','','0.4'});

% Use this axis with calcium spiking activity
% set(sub2,'box','off',...      % remove the box (unnecessary ink)
%     'tickdir','out', ...    % axis tick marks shouldn't collide with data
%     'xtick',0:0.25:2.5, ...     % a denser tick spacing improves lookup possibility
%     'xticklabel',{'0','','0.5','','1','','1.5','','2','','2.5'},...
%     'ytick',0:0.5:1.5, ...
%     'yticklabel',{'0','','1',''});


a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

set(hTitle,'FontSize',size_subtitle);

annotation('textbox',[0.13 0.745 .1 .1], ...
'String','$c_1$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);

annotation('textbox',[0.13 0.27 .1 .1], ...
'String','$c_2$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);

annotation('textbox',[0.8 0.03 .1 .1], ...
'String','$Time (s)$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_time_annotation);


set(findobj(gcf,'type','axes'),'linewidth',1.5);       % thicker curves
set(findobj(gcf,'type','axes'),'fontname','times');

xtickangle(findobj(gcf,'type','axes'),0) % rotate tick labels

% filename = 'figureB3b.pdf'; % save to file
% exportgraphics(f,filename);
end

