%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    TRIALS with different noise std dev                  %
%                       (same as denoising_main)                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Giulio Basso, 2022
% This file generates Fig. 13 in the paper by G. Basso, M. T. Barros,
% 'Biocomputing Model Using Tripartite Synapses Provides Reliable Neuronal
% Logic Gating with Spike Pattern Diversity'

% It calculates BER and accuracy for different noise levels. 
% 10 observations for each noise std dev. For each observation OR, AND, 
% OR+denoising, AND+denoising are tested.

clear variables; close all; clc

%% PARAMETERS CHOICE
% NEURON MODEL
neuron_type1 = 1; % always tonic spiking
neuron_type2 = 1;
neuron_type3 = 1;

% FLAG INPUTS ON/OFF (I of presynaptical neuron)
flag1=1;
flag2=0;

% DURATION STEP OF CURRENT
Tin1=500; % time instants that define the step of current
Tfin1=1500;

% Time definition
dt = 0.5;
T = 5000;

index=[1 1;  %OR gate
       3 2;  %OR gate + denoising
       2 1;  %AND gate
       4 3]; %AND gate + denoising
   
std_array=1:1:10; % std dev from 1 to 10
gate_string=["OR","ORd","AND","ANDd"];

BER_tot=zeros(10,5,4);
accu_tot=zeros(10,5,4);
v3_tot=zeros(10,5,4,T);

%% TRIES WITH DIFFERENT STD DEV
for i_noise=1:length(std_array)
    % noise
    noise_std = std_array(i_noise);

    %% 10 OBSERVATIONS FOR EACH STD DEV
    for k_obs=1:10
        noise=normrnd(0,noise_std,[T,1]);

        %% TRIES WITH DIFFERENT GATES
        for j_gate=1:4
            % CHOOSE LOGIC GATE TYPE
            gate_type=index(j_gate,1);
            if gate_type==1 || gate_type==3
                logic_type='OR';
            else
                logic_type='AND';
            end

            %SETTING ASTROCYTE CONTROL PARAMETERS
            astro_type1=index(j_gate,2);
            astro_type2=index(j_gate,2);

            % NEURONS INITIAL VALUES
            if (neuron_type1==2) % phasic spiking
                v_in1=-64; % Resting potential
                u_in1=-16;
            else
                v_in1=-70; % tonic spiking
                u_in1=-14; % Steadystate
            end

            if (neuron_type2==2)
                v_in2=-64;
                u_in2=-16;
            else
                v_in2=-70;
                u_in2=-14;
            end

            if (neuron_type3==2)
                v_in3=-64;
                u_in3=-16;
            else
                v_in3=-70;
                u_in3=-14;
            end

            % INPUT NEURON 1 SETTING
            % Reserve memory
            v1 = zeros (T, 1);
            u1 = zeros (T, 1);
            v1(1) = v_in1; 
            u1(1) = u_in1; 

            % INPUT NEURON 2 SETTING
            % Reserve memory
            v2 = zeros (T, 1);
            u2 = zeros (T, 1);
            v2(1) = v_in2;
            u2(1) = u_in2; 

            % POSTSYNAPTIC NEURON SETTING
            % Reserve memory
            v3 = zeros (T, 1);
            u3 = zeros (T, 1);
            v3(1) = v_in3;
            u3(1) = u_in3; 

            I_syn = zeros (T, 1);

            % ATROCYTE 1 SETTING
            % STATE VARIABLES
            I_syn_1=zeros(T,1);
            I_glion_1=zeros(T,1);
            C_1=zeros(T,1);
            Ce_1=zeros(T,1);
            Sm_1=zeros(T,1);
            Gm_1=zeros(T,1);

            g_syn1=0;

            % ATROCYTE 2 SETTING
            % STATE VARIABLES
            I_syn_2=zeros(T,1);
            I_glion_2=zeros(T,1);
            C_2=zeros(T,1);
            Ce_2=zeros(T,1);
            Sm_2=zeros(T,1);
            Gm_2=zeros(T,1);

            g_syn2=0;

            % EQUATIONS
            % For-loop over time
            for t = 1:T-1

                %----------------------------------------------------------------------
                % INPUT CURRENT 1
                %----------------------------------------------------------------------
                % Get input
                if (t*dt > Tin1 && t*dt < Tfin1)
                    I_flag1 = flag1;
                else
                    I_flag1 = 0;
                end

                %----------------------------------------------------------------------
                % INPUT CURRENT 2
                %----------------------------------------------------------------------
                % Get input
                if (t*dt > Tin1 && t*dt < Tfin1)
                    I_flag2 = flag2;
                else
                    I_flag2 = 0;
                end

                %----------------------------------------------------------------------
                % PRESYNAPTIC NEURON 1
                %----------------------------------------------------------------------
                [v1(t),v1(t+1),u1(t+1),p1] = presyn_neuron(neuron_type1,v1(t),u1(t),I_flag1,dt);

                %----------------------------------------------------------------------
                % PRESYNAPTIC NEURON 2
                %----------------------------------------------------------------------
                [v2(t),v2(t+1),u2(t+1),p2] = presyn_neuron(neuron_type2,v2(t),u2(t),I_flag2,dt);

                %----------------------------------------------------------------------
                % ASTROCYTE 1
                %----------------------------------------------------------------------
                [I_syn_1(t+1),I_glion_1(t+1),C_1(t+1),Ce_1(t+1),Sm_1(t+1),Gm_1(t+1),g_syn1] = astro(gate_type,astro_type1,v3(t),u3(t),C_1(t),Ce_1(t),Sm_1(t),Gm_1(t),dt,p1,g_syn1);

                %----------------------------------------------------------------------
                % ASTROCYTE 2
                %----------------------------------------------------------------------
                [I_syn_2(t+1),I_glion_2(t+1),C_2(t+1),Ce_2(t+1),Sm_2(t+1),Gm_2(t+1),g_syn2] = astro(gate_type,astro_type2,v3(t),u3(t),C_2(t),Ce_2(t),Sm_2(t),Gm_2(t),dt,p2,g_syn2);

                %----------------------------------------------------------------------
                % POSTSYNAPTIC NEURON EQUATIONS
                %----------------------------------------------------------------------
                I_syn(t+1)=I_syn_1(t+1)+I_syn_2(t+1)+noise(t+1);
                I_glion=I_glion_1(t+1)+I_glion_2(t+1);

                [v3(t),v3(t+1),u3(t+1)] = postsyn_neuron(neuron_type3,v3(t),u3(t),I_syn(t+1),I_glion,dt);

            end


            % SEPARATION IN BINS
            [bin,bin1,bin2] = bin_segmentation(v1,v2,Tfin1,dt);

            % ERROR ANALYSIS
            [hamming_dist,BER] = bit_error(logic_type,[flag1 flag2],v1,v2,v3,bin);
            [TP,TN,FP,FN,accu] = accuracy(logic_type,[flag1 flag2],v3,bin1,bin2);

            BER_tot(i_noise,k_obs,j_gate)=BER;
            accu_tot(i_noise,k_obs,j_gate)=accu;

            v3_tot(i_noise,k_obs,j_gate,:)=v3;

            % FIGURE FOR NOISY CASE (grid)
            %             figure_neuron_noisy(logic_type,v1,v2,v3,bin,T,dt)

        end
    end
end

%% FIGURES
% Font size
size_title=25;
size_label=25;
size_ticks=25;
size_legend=25;


% FIGURE BER
errors_ber=std(BER_tot(:,:,:),0,2);

figure, hold on
errorbar(std_array,mean(BER_tot(:,:,1),2),errors_ber(:,:,1),'bo','MarkerSize',15,'LineWidth',1);
errorbar(std_array,mean(BER_tot(:,:,2),2),errors_ber(:,:,2),'g^','MarkerSize',15,'LineWidth',1);
errorbar(std_array,mean(BER_tot(:,:,3),2),errors_ber(:,:,3),'rx','MarkerSize',15,'LineWidth',1);
errorbar(std_array,mean(BER_tot(:,:,4),2),errors_ber(:,:,4),'ms','MarkerSize',15,'LineWidth',1);
legend('OR','ORd','AND','ANDd','fontsize',size_legend);
hold off
% title("{\itBit error ratio with inputs}"+" ["+flag1+" "+flag2+"]",'fontsize',size_title,'FontWeight','Normal','FontWeight','Bold');
title("{\itLogic operation error ratio with inputs}"+" ["+flag1+" "+flag2+"]",'fontsize',size_title,'FontWeight','Normal','FontWeight','Bold');

axis([1 10 0 100])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

xlabel('{\itNoise standard deviation}','fontsize',size_label)    % label the x-axis (italic)
% ylabel('{\itBER}','fontsize',size_label, ...                  % label the y-axis
%         'rot',0,'horizontalAlignment','right')               % rotate it to read left-to-right
ylabel('{\itLER}','fontsize',size_label, ...                  % label the y-axis
    'rot',0,'horizontalAlignment','right')               % rotate it to read left-to-right
grid on

% Settings
set(findobj(gcf,'type','axes'),'box','off',...      % remove the box (unnecessary ink)
    'tickdir','out', ...    % axis tick marks shouldn't collide with data
    'xtick',1:1:10, ...     % a denser tick spacing improves lookup possibility
    'xticklabel',{'1','','3','','5','','7','','9',''}, ...  % remove unnecessary tick labels
    'ytick',0:5:100,'yticklabel',{'0','','','15','','','30','','',...
    '45','','','60','','','75','','','90','',''})         % ditto for y ticks and their labels
set(findobj(gcf,'type','axes'),'linewidth',1)             % thicker curves
set(findobj(gcf,'type','axes'),'fontname','times')


% FIGURE ACCURACY
errors_accu=std(accu_tot(:,:,:),0,2);

figure, hold on
errorbar(std_array,mean(accu_tot(:,:,1),2),errors_accu(:,:,1),'bo','MarkerSize',15,'LineWidth',1);
errorbar(std_array,mean(accu_tot(:,:,2),2),errors_accu(:,:,2),'g^','MarkerSize',15,'LineWidth',1);
errorbar(std_array,mean(accu_tot(:,:,3),2),errors_accu(:,:,3),'rx','MarkerSize',15,'LineWidth',1);
errorbar(std_array,mean(accu_tot(:,:,4),2),errors_accu(:,:,4),'ms','MarkerSize',15,'LineWidth',1);
legend('OR','ORd','AND','ANDd','fontsize',size_legend);
hold off
xlm=xlim; % retrieve x axis limits
title({"{\itAccuracy with inputs}"+" ["+flag1+" "+flag2+"]"},'fontsize',size_title,'FontWeight','Normal','Position',[mean(xlm) xlm(1)+0.015],'FontWeight','Bold');

axis([1 10 0 1])
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',size_ticks);

xlabel('{\itNoise standard deviation}','fontsize',size_label)    % label the x-axis (italic)
ylabel('{\itAccuracy}','fontsize',size_label, ...                  % label the y-axis
    'rot',0,'horizontalAlignment','right')               % rotate it to read left-to-right
grid on

% Settings
set(findobj(gcf,'type','axes'),'box','off',...      % remove the box (unnecessary ink)
    'tickdir','out', ...    % axis tick marks shouldn't collide with data
    'xtick',1:1:10, ...     % a denser tick spacing improves lookup possibility
    'xticklabel',{'1','','3','','5','','7','','9',''}, ...  % remove unnecessary tick labels
    'ytick',0:0.1:1,'yticklabel',{'0','','0.2','','0.4','','0.6','','0.8','','1'})         % ditto for y ticks and their labels
set(findobj(gcf,'type','axes'),'linewidth',1)             % thicker curves
set(findobj(gcf,'type','axes'),'fontname','times')
