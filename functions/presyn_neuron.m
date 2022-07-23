function [v0,v,u,p] = presyn_neuron(neuron_type,v0,u0,I_flag,dt)
% Author: Giulio Basso, 2022
% Function used for the update of the Izhikevich model of presynaptic neuron 
% within a tripartite synapse, in the paper by G. Basso, M. T. Barros,
% 'Biocomputing Model Using Tripartite Synapses Provides% Reliable Neuronal 
% Logic Gating with Spike Pattern Diversity'

%INPUT:
%  neuron_type: number indicating the spiking pattern, selected between [1 6]
%  v0: actual value of presynaptic v1(t) (or initial value)
%  u0: actual value of presynaptic u1(t) (or initial value)
%  I_flag: flag 1 means I_app=ON, flag 0 I_app=OFF (the amplitude of current
%          depend on the selected spiking pattern)
%  dt: time step
%OUTPUT:
%  v0: updated value of presynaptic v1(t) (if v0>30 we need to set v0=30)
%  v:  updated value of presynaptic v1(t+1)
%  u:  updated value of presynaptic u1(t+1)

%% SPIKING PARAMETERS
pars=[0.02      0.2     -65      6       4 ;...    % 1)tonic spiking
      0.02      0.25    -65      6       0.5 ];    % 2)phasic spiking
      
% Initialize spiking parameters
a = pars(neuron_type ,1);
b = pars(neuron_type ,2);
c = pars(neuron_type ,3);
d = pars(neuron_type ,4);
I = pars(neuron_type ,5);

% Set input current
I_app=I*I_flag;

p=0;

%% IZHIKEVICH UPDATE

if v0 < 30
        % Update system of ODEs (Ordinary Differential Equations)
        dv = (0.04* v0+5)*v0 + 140 - u0 + I_app;
        v = v0 + dv*dt;
        du = a*(b*v0-u0);                      % ----- WRITE HERE ODE FOR VARIABLE u
        u = u0 + du*dt;
    else
        % Spike!
        v0 = 30;
        v = c;
        u = u0+d;
        
        p=1;
end
 
end

