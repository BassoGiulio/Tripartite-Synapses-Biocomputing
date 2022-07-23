function [I_syn,I_glion,C,Ce,Sm,Gm,g_syn] = astro(gate_type,astro_type,v,u2,C,Ce,Sm,Gm,dt,p,g_syn)
% Author: Giulio Basso, 2022
% Function used for the tripartite synapse model with synaptic conductance
% in the paper by G. Basso, M. T. Barros,
% 'Biocomputing Model Using Tripartite Synapses Provides% Reliable Neuronal 
% Logic Gating with Spike Pattern Diversity'


%INPUT:
%  gate_type: choose gate type for setting w_in
%  astro_type: setting for control parameters, number in range [0 6]
%  v: v(t) of postsynaptic neuron
%  u2: u(t) recovery variable of postsynaptic neuron
%  C: actual value C(t)
%  Ce: actual value Ce(t)
%  Sm: actual value Sm(t)
%  Gm: actual value Gm(t)
%  dt: time step
%  p: flag for synaptic conductance update
%  g_syn: synaptic conductance
%OUTPUT:
%  I_syn: synaptic current that has to be applied to the postsynaptic neuron
%  I_glion: glion current that has to be applied to the postsynaptic neuron
%  Z: updated value v(t+1)
%  C: updated value C(t+1)
%  Ce: updated value Ce(t+1)
%  Sm: updated value Sm(t+1)
%  Gm: updated value Gm(t+1)
%  g_syn: updated synaptic conductance

%% GATE TYPE
pars_gate=[% TONIC SPIKING
           0.09    % 1)OR 
           0.05    % 2)AND 
           0.22    % 3)OR with denoising
           0.11    % 4)AND denoising
           % PHASIC SPIKING 
           0.02    % 5)OR
           0.01];  % 6)AND
 
w_in=pars_gate(gate_type); 
%% PARAMETERS
%--------------------------------------------------------------------------
% CONTROL PARAMETERS
%--------------------------------------------------------------------------
% gamma=0, delta=0 means no FB to the neural dynamics
% alpha=0 fast act. pathway off
% beta=0, slow act. pathway off

pars_astro=[0        0         0        0;    % 1)Astrocyte OFF
            0        0.05      0        15;   % 2)OR with denoising
            0        0.05      1.5      10];  % 3)AND with denoising (tonic spiking)  

alpha=pars_astro(astro_type,1);
beta=pars_astro(astro_type,2);
gamma=pars_astro(astro_type,3);
delta=pars_astro(astro_type,4);
%--------------------------------------------------------------------------
% FIXED PARAMETERS
%--------------------------------------------------------------------------

% Modified two-pool model parameters
tau_c=8;
r=0.31; % Postnov et al.
eps_c=0.04;
k1=0.13;  % constants on calcium equations (small letter c are used in Izhikevich model yet)
k2=0.9;
k3=0.004;
k4=2/eps_c;

% glion mediator and IP3 mediator  production parameters
tau_sm=100;
s_sm=100;
h_sm=0.45;
d_sm=3;
tau_gm=50;
s_gm=100;
h_gm=0.5;
d_gm=3;

tau_g = 10; % of synapse model with g_in
E=0; %reversal potential excitatory synapses
%--------------------------------------------------------------------------
% EQUATIONS
%--------------------------------------------------------------------------
% Synaptic coupling equations
g_syn = g_syn + p;
I_syn = w_in*(g_syn.*E) - (w_in*g_syn)*v - delta*Gm;
g_syn = (1 - dt / tau_g )*g_syn;

% Modified two-pool model
f=k1*C^2/(1+C^2)-(Ce^2/(1+Ce^2))*(C^4/(k2^4+C^4))-k3*Ce;

dC=1/tau_c*(-C-k4*f+(r+alpha*u2+beta*Sm));
C=C+dC*dt;

dCe=1/eps_c*1/tau_c*f;
Ce=Ce+dCe*dt;

% glion mediator and IP3 mediator  production
dSm=1/tau_sm*((1+tanh(s_sm*(g_syn-h_sm)))*(1-Sm)-Sm/d_sm);
Sm=Sm+dSm*dt;

dGm=1/tau_gm*((1+tanh(s_gm*(C-h_gm)))*(1-Gm)-Gm/d_gm);
Gm=Gm+dGm*dt;

I_glion=gamma*Gm;
end

