%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           Network_complete:
% Logic gate model made by two input neurons, connected to the same output
% neuron through two tripartite synapses. Neurons are stimulated by a
% step of current and they can fire with tonic or phasic firing pattern.
% Optionally with synaptic gaussian noise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables; close all; clc

%--------------------------------------------------------------------------
%% PARAMETERS CHOICE
% LOGIC GATE TYPE
% Tonic spike:
% 1)OR
% 2)AND
% 3)OR with astrocytes
% 4)AND with astrocytes
% Phasic spike:
% 5)OR
% 6)AND

gate_type=6; % <-- CHOOSE HERE

if gate_type==1 || gate_type==3 || gate_type==5
    logic_type='OR';
else
    logic_type='AND';
end

% SETTING NEURON MODEL
if gate_type==5 || gate_type==6 % phasic spiking cases
    neuron_type1 = 2; % 1=tonic spiking, 2=phasic spiking
    neuron_type2 = 2;
    neuron_type3 = 2;
else
    neuron_type1 = 1;
    neuron_type2 = 1;
    neuron_type3 = 1;
end

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

% FLAG INPUTS ON/OFF (I of presynaptic neurons)
flag1=1; % CHOOSE HERE 1=ON, 0=OFF
flag2=1;

% DURATION STEP OF CURRENT (ms)
Tin=500; % time instants that define the step of current
Tfin=1500;

% Time definition
dt = 0.5;
T = ceil(4000/dt);

%% NEURONS INITIAL VALUES
if (neuron_type1==2) % phasic spiking
    v_in1=-64; % Resting potential
    u_in1=-16; % Steadystate
else
    v_in1=-70; % tonic spiking
    u_in1=-14;
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

%% NEURONS SETTING
% INPUT NEURON 1
v1 = zeros (T, 1);
u1 = zeros (T, 1);
v1(1) = v_in1; 
u1(1) = u_in1; 

% INPUT NEURON 2
v2 = zeros (T, 1);
u2 = zeros (T, 1);
v2(1) = v_in2;
u2(1) = u_in2;

% OUTPUT NEURON
v3 = zeros (T, 1);
u3 = zeros (T, 1);
v3(1) = v_in3;
u3(1) = u_in3;

I_syn = zeros (T, 1);

%% ATROCYTES SETTING
% ASTROCYTE 1
I_syn_1=zeros(T,1);
I_glion_1=zeros(T,1);
C_1=zeros(T,1);
Ce_1=zeros(T,1);
Sm_1=zeros(T,1);
Gm_1=zeros(T,1);

g_syn1=0;

% ATROCYTE 2
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
    if t*dt > Tin && t*dt < Tfin
        I_flag1 = flag1;
    else
        I_flag1 = 0;
    end

    %----------------------------------------------------------------------
    % INPUT CURRENT 2
    %----------------------------------------------------------------------
    % Get input
    if t*dt > Tin && t*dt < Tfin
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
    I_syn(t+1)=I_syn_1(t+1)+I_syn_2(t+1);
    I_glion=I_glion_1(t+1)+I_glion_2(t+1);

    [v3(t),v3(t+1),u3(t+1)] = postsyn_neuron(neuron_type3,v3(t),u3(t),I_syn(t+1),I_glion,dt);

end

%% INTERSPIKE INTERVAL
% [isi,f_inter] = firing_freq(v3,dt);

%% FIGURE ONLY NEURON
figure_neuron(logic_type,v1,v2,v3,T,dt)

%% FIGURE ASTRO
% figure_calcium(C_1,C_2,T,dt)
