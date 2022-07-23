function [TP,TN,FP,FN,accu] = accuracy(logic_type,flags,v3,bin1,bin2)
% Author: Giulio Basso, 2022
% Function used to calculate the accuracy in the paper by G. Basso, 
% M. T. Barros, 'Biocomputing Model Using Tripartite Synapses Provides 
% Reliable Neuronal Logic Gating with Spike Pattern Diversity'

% spike=positive, resting state=negative
bin=[bin1; bin2];

flag1=flags(1);
flag2=flags(2);

if strcmp(logic_type,'AND')

    if and(flag1,flag2)==1
        output_level=1; %ON
    else
        output_level=0; %OFF
    end

else if strcmp(logic_type,'OR')

        if or(flag1,flag2)==1
            output_level=1; %ON
        else
            output_level=0; %OFF
        end

else
    fprintf('ERROR: not valid inputs');
    return;
end
end

%% COUNT OF TP TN FP FN
TP=0; TN=0; FP=0; FN=0;

if output_level==1
    % CASE WITH OUTPUT ON
    % First interval (ON)
    for i=1:length(bin1)-1
        inter_spike=(bin1(i):bin1(i+1)-1);
        num_peaks=numel(find(v3(inter_spike)==30));

        %false negative
        if num_peaks==0
            FN=FN+1;
        end

        %true positive
        if num_peaks>=1
            TP=TP+1;
        end

        %false positive
        if num_peaks>1
            FP=FP+num_peaks-1;
        end
    end
    %last bin between bin1 and bin2 (OFF)
    inter_spike=(bin1(end):bin2(1)-1);
    num_peaks=numel(find(v3(inter_spike)==30));

    %true negative
    if num_peaks==0
        TN=TN+1;

    else
        %false positive
        FP=FP+num_peaks;
    end

    % Second interval (OFF)
    for i=1:length(bin2)-1
        inter_spike=(bin2(i):bin2(i+1)-1);
        num_peaks=numel(find(v3(inter_spike)==30));

        %true negative
        if num_peaks==0
            TN=TN+1;

        else
            %false positive
            FP=FP+num_peaks;
        end
    end
    %last bin between bin1 and bin2 (OFF)
    inter_spike=(bin2(end):length(v3));
    num_peaks=numel(find(v3(inter_spike)==30));

    %true negative
    if num_peaks==0
        TN=TN+1;

    else
        %false positive
        FP=FP+num_peaks;
    end

else
    %% CASE WITH OUTPUT OFF

    for i=1:length(bin)-1
        inter_spike=(bin(i):bin(i+1)-1);
        num_peaks=numel(find(v3(inter_spike)==30));

        %true negative
        if num_peaks==0
            TN=TN+1;

        else
            %false positive
            FP=FP+num_peaks;
        end
    end

    %last bin (OFF)
    inter_spike=(bin(end):length(v3));
    num_peaks=numel(find(v3(inter_spike)==30));

    %true negative
    if num_peaks==0
        TN=TN+1;

    else
        %false positive
        FP=FP+num_peaks;
    end

end

%% Accuracy (or Fraction Correct FC)
accu=(TP+TN)/(TP+TN+FP+FN);

end

