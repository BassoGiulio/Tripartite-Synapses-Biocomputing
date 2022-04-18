function [bin,bin1,bin2] = bin_segmentation(v1,v2,Tfin1,dt)

% FIRST STEP SIGNAL
[pks1,locs1] = findpeaks(v1,'MinPeakHeight',25);
[pks2,locs2] = findpeaks(v2,'MinPeakHeight',25);

% Choose the right reference
locs_ref=locs1(find(locs1<Tfin1/dt+1)); % take only the piece of the first step
v_ref=v1;
if length(locs1)==0 & length(locs2)~=0
    locs_ref=locs2(find(locs2<Tfin1/dt+1));
    v_ref=v2;
end

bin1=zeros(length(locs_ref)+1,1);
bin1(1)=locs_ref(1)-fix((locs_ref(2)-locs_ref(1))/2);
figure, plot(v_ref,'linewidth',1), hold on, xline(bin1(1),'--k','linewidth',1);
for i=1:length(locs_ref)-1
    bin1(i+1)=locs_ref(i)+fix((locs_ref(i+1)-locs_ref(i))/2);
    xline(bin1(i+1),'--k','linewidth',1);
end
bin1(end)=locs_ref(end)+fix((locs_ref(end)-locs_ref(end-1))/2);
xline(bin1(end),'--k','linewidth',1);

% LOW LEVEL

bin2=bin1(2:end-1)-bin1(1)+bin1(end);
xline(bin2(1),'--b','linewidth',1);
for i=1:length(bin2)-1
    xline(bin2(i+1),'--b','linewidth',1);
end

bin=[bin1; bin2];
close
end

