function [hamming_dist,BER] = bit_error(logic_type,flags,v1,v2,v3,bin)

%INPUT:
%   logic_type: string with 'AND' or 'OR'
%   flags: [flag1 flag2] ON/OFF flag of the inputs
%   v1,v2,v3: Izhikevich membrane voltage
%   bin: segmentation in bin of the signals

flag1=flags(1);
flag2=flags(2);

% Choose the right reference
[pks1,locs1] = findpeaks(v1,'MinPeakHeight',25);
[pks2,locs2] = findpeaks(v2,'MinPeakHeight',25);

if strcmp(logic_type,'AND')
    
    if and(flag1,flag2)==1
        v_ref=v1;
    else % the reference is the OFF signal
        if length(locs1)==0
            v_ref=v1;
        else
            v_ref=v2;
        end
    end
    
else if strcmp(logic_type,'OR')
        
        v_ref=v1;
        % if one is ON and the other OFF take the ON signal
        if length(locs1)==0 & length(locs2)~=0
            v_ref=v2;
        end
        
    else
        fprintf('ERROR: not valid inputs');
        return;
    end
end



% Conversion of signals in string of bits
bit_ref=zeros(length(bin),1);
bit_3=zeros(length(bin),1);
for i=1:length(bin)-1
    
    inter_spike=(bin(i):bin(i+1)-1);
    
    num_peaks_ref=numel(find(v_ref(inter_spike)==30));
    if num_peaks_ref==0
        bit_ref(i)=0;
    else
        bit_ref(i)=1;
    end
    
    num_peaks_3=numel(find(v3(inter_spike)==30));
    if num_peaks_3==0
        bit_3(i)=0;
    else
        bit_3(i)=1;
    end
end

%LAST BIN (from the bin(end) to the end of the signal)
inter_spike=(bin(16):length(v_ref));
    
    num_peaks_ref=numel(find(v_ref(inter_spike)==30));
    if num_peaks_ref==0
        bit_ref(16)=0;
    else
        bit_ref(16)=1;
    end
    
    num_peaks_3=numel(find(v3(inter_spike)==30));
    if num_peaks_3==0
        bit_3(16)=0;
    else
        bit_3(16)=1;
    end

hamming_dist=sum(xor(bit_ref,bit_3));
BER=hamming_dist/(length(bin))*100;

end

