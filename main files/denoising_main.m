%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              denoising_main                             %
%      Same code as network_main but with synaptic Gaussian noise  
%                        (only for tonic spike)                           %          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Giulio Basso, 2022
% This file generates Fig. 9-12 in the paper by G. Basso, M. T. Barros,
% 'Biocomputing Model Using Tripartite Synapses Provides Reliable Neuronal
% Logic Gating with Spike Pattern Diversity'

clear variables; close all; clc
% rng(1,'twister'); rng(1); % generate always the same random noise

%--------------------------------------------------------------------------
%% PARAMETERS CHOICE
% LOGIC GATE TYPE
% Tonic spike:
% 1)OR
% 2)AND
% 3)OR with astrocytes (denoising)
% 4)AND with astrocytes (denoising)

gate_type=4; % <-- CHOOSE HERE

if gate_type==1 || gate_type==3
    logic_type='OR';
else
    logic_type='AND';
end

% SETTING NEURON MODEL
neuron_type1 = 1; % always tonic spiking (1=tonic spiking, 2=phasic spiking)
neuron_type2 = 1;
neuron_type3 = 1;

%SETTING ASTROCYTE CONTROL PARAMETERS
% 1)Astrocyte OFF
% 2)OR with astrocytes
% 3)AND with astrocytes
if gate_type==3
    astro_type1=2;
    astro_type2=2;
else if gate_type==4
        astro_type1=3;
        astro_type2=3;
else
    astro_type1=1;
    astro_type2=1;
end
end

% FLAG INPUTS ON/OFF 1=ON, 0=OFF
flag1=1; % <-- CHOOSE HERE
flag2=0;

% DURATION STEP OF CURRENT (ms)
Tin=500; % time instants that define the step of current
Tfin=1500;

% Time definition
dt = 0.5;
T = 5000;

%% NOISE (only for tonic spike)
% noise_std = 5.;
% noise=normrnd(0,noise_std,[T,1]);

load('noise_5.mat') % use a stored observation
% noise=zeros(T,1); % switch off noise

%% NEURONS INITIAL VALUES
v_in1=-70; % tonic spiking
u_in1=-14;

v_in2=-70;
u_in2=-14;

v_in3=-70;
u_in3=-14;

%% INPUT NEURON 1 SETTING
v1 = zeros (T, 1);
u1 = zeros (T, 1);
v1(1) = v_in1;
u1(1) = u_in1;

%% INPUT NEURON 2 SETTING
v2 = zeros (T, 1);
u2 = zeros (T, 1);
v2(1) = v_in2;
u2(1) = u_in2;

%% POSTSYNAPTIC NEURON SETTING
v3 = zeros (T, 1);
u3 = zeros (T, 1);
v3(1) = v_in3;
u3(1) = u_in3;

I_syn = zeros (T, 1);

%% ATROCYTE 1 SETTING
% STATE VARIABLES
I_syn_1=zeros(T,1);
I_glion_1=zeros(T,1);
C_1=zeros(T,1);
Ce_1=zeros(T,1);
Sm_1=zeros(T,1);
Gm_1=zeros(T,1);

g_syn1=0;

%% ATROCYTE 2 SETTING
% STATE VARIABLES
I_syn_2=zeros(T,1);
I_glion_2=zeros(T,1);
C_2=zeros(T,1);
Ce_2=zeros(T,1);
Sm_2=zeros(T,1);
Gm_2=zeros(T,1);

g_syn2=0;

%% EQUATIONS
% For-loop over time
for t = 1:T-1

    %----------------------------------------------------------------------
    % INPUT CURRENT 1
    %----------------------------------------------------------------------
    % Get input
    if (t*dt > Tin && t*dt < Tfin)
        I_flag1 = flag1;
    else
        I_flag1 = 0;
    end

    %----------------------------------------------------------------------
    % INPUT CURRENT 2
    %----------------------------------------------------------------------
    % Get input
    if (t*dt > Tin && t*dt < Tfin)
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


%% SEGMENTATION IN BINS
[bin,bin1,bin2] = bin_segmentation(v1,v2,Tfin,dt);

%% ERROR ANALYSIS
[hamming_dist,BER] = bit_error(logic_type,[flag1 flag2],v1,v2,v3,bin)
[TP,TN,FP,FN,accu] = accuracy(logic_type,[flag1 flag2],v3,bin1,bin2)

%% FIGURE FOR NOISY CASE (with grid)
figure_neuron_noisy(logic_type,v1,v2,v3,bin,T,dt)
% print('-depsc2','-r600','neuron_noisy_or1.eps') % Print to file
