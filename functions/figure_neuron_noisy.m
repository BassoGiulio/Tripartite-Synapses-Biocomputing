function [] = figure_neuron_noisy(logic_type,v1,v2,v3,bin,T,dt)
%figure_neuron_noisy2: figure for noisy and denoised simulations

size_title=40;
size_subtitle=35;
size_ON_OFF=35;
size_ticks=35;
size_annotation=35;
size_mV=30;
size_time_annotation=30;

% Plot 4 seconds
t=(0:1:T-1)*dt*10^-3; % (t in seconds)
bin_s=(bin-1)*dt*10^-3;

f = figure;
if strcmp(logic_type,'AND')
    sgtitle({'{\itAND gate}\fontsize{6}','{\fontsize{6}}'},'fontsize',size_title,'fontname','times','FontWeight','Bold')
else
%    sgtitle('{\itOR gate}','fontsize',size_title,'fontname','times','FontWeight','Bold')
   sgtitle({'{\itOR gate}\fontsize{6}','{\fontsize{6}}'},'fontsize',size_title,'fontname','times','FontWeight','Bold')

end

%% USING GRAY PATCHES
X1=[0.5 1.5 1.5 0.5];
Y1=[-90 -90 30 30];

X2=[1.5 2.5 2.5 1.5];
Y2=Y1;

subplot(3,1,1), plot(t,v1), hold on,
patch(X1,Y1,[0,0,0]+0.85,'FaceAlpha',.4,'EdgeColor','none')
patch(X2,Y2,[0,0,0]+0.55,'FaceAlpha',.4,'EdgeColor','none')
plot(t,v1,'Color',[0 0.4470 0.7410],'linewidth',1)
for i=1:length(bin_s)
    xline(bin_s(i),'--','linewidth',0.8);
end
hold off

hTitle=title({'{\itINPUT neuron 1}',''});
% set(hTitle,'fontsize',size_subtitle,'FontWeight','Normal','FontName','Times');
set(hTitle,'FontSize',size_subtitle,'FontWeight','Normal','FontName','Times','Position',[1.25 7 0]);

text(0.9,48,'{\it ON}','fontsize',size_ON_OFF,'fontname','times')
text(1.88,48,'{\it OFF}','fontsize',size_ON_OFF,'fontname','times')
axis([0 t(end) -90 30])

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

text(0.04,15,'$v_1$','fontsize',size_annotation,'fontname','times','Interpreter','latex')


subplot(3,1,2), plot(t,v2), hold on,
patch(X1,Y1,[0,0,0]+0.85,'FaceAlpha',.4,'EdgeColor','none')
patch(X2,Y2,[0,0,0]+0.55,'FaceAlpha',.4,'EdgeColor','none')
plot(t,v2,'Color',[0 0.4470 0.7410],'linewidth',1)
for i=1:length(bin_s)
    xline(bin_s(i),'--','linewidth',0.8);
end
hold off

hTitle=title('{\itINPUT neuron 2}');
set(hTitle,'fontsize',size_subtitle,'FontWeight','Normal','FontName','Times');

axis([0 t(end) -90 30])

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

text(0.04,15,'$v_2$','fontsize',size_annotation,'fontname','times','Interpreter','latex')

 
subplot(3,1,3), plot(t,v3), hold on,
patch(X1,Y1,[0,0,0]+0.85,'FaceAlpha',.4,'EdgeColor','none')
patch(X2,Y2,[0,0,0]+0.55,'FaceAlpha',.4,'EdgeColor','none')
plot(t,v3,'r','linewidth',1)
for i=1:length(bin_s)
    xline(bin_s(i),'--','linewidth',0.8);
end
hold off

hTitle=title('{\itOUTPUT neuron}');
set(hTitle,'fontsize',size_subtitle,'FontWeight','Normal','FontName','Times');

axis([0 t(end) -90 30])

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

text(0.04,15,'$v_3$','fontsize',size_annotation,'fontname','times','Interpreter','latex')

text(2.1,-120,'$Time (s)$','fontsize',size_time_annotation,'fontname','times','Interpreter','latex')
    
annotation('textbox',[0.05 0.81 .1 .1], ...
'String','$(mV)$','Interpreter','latex','EdgeColor','none','fontname','times','fontsize',size_mV);

%% Settings
xtickangle(findobj(gcf,'type','axes'),0)

set(findobj(gcf,'type','axes'),'box','off',...      % remove the box (unnecessary ink)
     'tickdir','out', ...    % axis tick marks shouldn't collide with data 
     'xtick',0:.25:2.5, ...     % a denser tick spacing improves lookup possibility 
     'xticklabel',{'0','','0.5','','1','','1.5','','2','','2.5'}, ...  % remove unnecessary tick labels
     'ytick',-90:30:30,'yticklabel',{'-90','','-30','','30'})         % ditto for y ticks and their labels
set(findobj(gcf,'type','axes'),'linewidth',1)             % thicker curves
set(findobj(gcf,'type','axes'),'fontname','times')

pos = get(gcf, 'Position');
set(gcf, 'Position',pos+[0 -400 0 400])


% filename = 'figureD4.pdf'; % save to file
% exportgraphics(f,filename);
end

