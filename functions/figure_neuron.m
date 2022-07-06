function [] = figure_neuron(logic_type,v1,v2,v3,T,dt)
%figure_neuron1: figure of only neurons without noise

% Font size
size_title=40;
size_subtitle=35;
size_ticks=35;
size_annotation=35;
size_mV=30;
size_time_annotation=30;

%% Plot 1 seconds (for phasic)
% t=(0:1:(T-1)*(1/4))*dt*10^-3; % (t in seconds)
% 
% f = figure;
% if strcmp(logic_type,'AND')
%     sgtitle('{\itAND gate}','fontsize',size_title,'fontname','times','FontWeight','Bold')
% else
%     sgtitle('{\itOR gate}','fontsize',size_title,'fontname','times','FontWeight','Bold')
% end
% 
% subplot(3,1,1), plot(t,v1(1:T*(1/4)),'linewidth',1)
% hTitle = title('{\itINPUT neuron 1}');
% axis([0 t(end) -90 30]);
% 
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);
% 
% set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times','Position',[0.5 35 0]);
%     
% 
% 
% subplot(3,1,2), plot(t,v2(1:T*(1/4)),'linewidth',1)
% hTitle = title('{\itINPUT neuron 2}');
% axis([0 t(end) -90 30]);
% 
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);
% 
% set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times');
%     
%     
% 
% subplot(3,1,3), plot(t,v3(1:T*(1/4)),'r','linewidth',1)
% hTitle = title('{\itOUTPUT neuron}');
% axis([0 t(end) -90 30]);
% 
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);
% 
% set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times');
% 
% annotation('textbox',[0.05 0.825 .1 .1], ...
% 'String','$(mV)$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_mV);
% 
% annotation('textbox',[0.77 0.03 .1 .1], ...
% 'String','$Time (s)$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_time_annotation);
%     
% %Membrane potential labels
% annotation('textbox',[0.13 0.774 .1 .1], ...
% 'String','$v_1$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);
% annotation('textbox',[0.13 0.485 .1 .1], ...
% 'String','$v_2$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);
% annotation('textbox',[0.13 0.194 .1 .1], ...
% 'String','$v_3$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);
%     
% % Settings
% set(findobj(gcf,'type','axes'),'box','off',...      % remove the box (unnecessary ink)
%      'tickdir','out', ...    % axis tick marks shouldn't collide with data 
%      'xtick',0:.25:1, ...     % a denser tick spacing improves lookup possibility 
%      'xticklabel',{'0','0.25','0.5','0.75','1'}, ...  % remove unnecessary tick labels
%      'ytick',-90:30:30,'yticklabel',{'-90','','-30','','30'});         % ditto for y ticks and their labels
% set(findobj(gcf,'type','axes'),'linewidth',1);             % thicker curves


%% Plot only first two seconds (for tonic)
t=(0:1:(T-1)/2)*dt*10^-3; % (t in seconds)


f = figure;
if strcmp(logic_type,'AND')
    sgtitle('{\itAND gate}','fontsize',size_title,'fontname','times','FontWeight','Bold')
else
    sgtitle('{\itOR gate}','fontsize',size_title,'fontname','times','FontWeight','Bold')
end

subplot(3,1,1), plot(t,v1(1:T/2),'linewidth',1.5)
hTitle = title('{\itINPUT neuron 1}');
axis([0 t(end) -90 30]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times','Position',[1. 30 0]);
    


subplot(3,1,2), plot(t,v2(1:T/2),'linewidth',1.5)
hTitle = title('{\itINPUT neuron 2}');
axis([0 t(end) -90 30]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times');
    
    

subplot(3,1,3), plot(t,v3(1:T/2),'r','linewidth',1.5)
hTitle = title('{\itOUTPUT neuron}');
axis([0 t(end) -90 30]);

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times');

annotation('textbox',[0.05 0.825 .1 .1], ...
'String','$(mV)$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_mV);

annotation('textbox',[0.77 0.028 .1 .1], ...
'String','$Time (s)$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_time_annotation);
    
%Membrane potential labels
annotation('textbox',[0.13 0.774 .1 .1], ...
'String','$v_1$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);
annotation('textbox',[0.13 0.485 .1 .1], ...
'String','$v_2$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);
annotation('textbox',[0.13 0.194 .1 .1], ...
'String','$v_3$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_annotation);
    
% Settings
set(findobj(gcf,'type','axes'),'box','off',...      % remove the box (unnecessary ink)
     'tickdir','out', ...    % axis tick marks shouldn't collide with data 
     'xtick',0:.25:2, ...     % a denser tick spacing improves lookup possibility 
     'xticklabel',{'0','','0.5','','1','','1.5','','2'}, ...  % remove unnecessary tick labels
     'ytick',-90:30:30,'yticklabel',{'-90','','-30','','30'})         % ditto for y ticks and their labels
set(findobj(gcf,'type','axes'),'linewidth',1)             % thicker curves
set(findobj(gcf,'type','axes'),'fontname','times')

%%
xtickangle(findobj(gcf,'type','axes'),0) % rotate tick labels

pos = get(gcf, 'Position');
set(gcf, 'Position',pos+[0 -400 0 400])

% filename = 'figureB4a.pdf'; % save to file
% exportgraphics(f,filename);

end

