function [isi,f_inter] = firing_freq(v,dt)
% Author: Giulio Basso, 2022
% Function used for calculating the neurons' firing frequency
% in the paper by G. Basso, M. T. Barros,
% 'Biocomputing Model Using Tripartite Synapses Provides% Reliable Neuronal 
% Logic Gating with Spike Pattern Diversity'

% INPUT: v membrane potential (of a tonic spiking neuron)
%        dt time step
% OUPTUT: isi interspike interval (ms)
%         f_inter interspike frequency (Hz)

[pks,locs]=findpeaks(v,'MinPeakHeight',25);

figure
findpeaks(v,'MinPeakHeight',25) %PLOT THE PEAKS

isi=0;
for i=1:length(locs)-1
    isi=isi+locs(i+1)-locs(i);
end

isi=isi/numel(2:length(locs)-1)*dt; % in ms
f_inter=1/isi*10^3; %Hz
end

