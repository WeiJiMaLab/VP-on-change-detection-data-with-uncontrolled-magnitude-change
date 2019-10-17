% Weiji Ma, 20140601
close all; clear all; h = colormap(lines);

%% Synthetic data
% 
% Nsubj = 10;
% Ntrials = 1000;
% Nvec = [1 2 4 8];
% alldata = [];
% for subjid = 1:Nsubj
%     J1bar = 30+rand*40;
%     alpha = 1+rand*0.4;
%     tau = 20+rand*40;
%     data = CDsimple_generatedata(J1bar, alpha, tau, Nvec, Ntrials);
%     alldata = [alldata; ones(4,1)*subjid data];
% end

load data

data = alldata;
allsubjid = data(:,1);
alln = data(:,2);
allchange = data(:,3);
allhi = data(:,4);
allnochange = data(:,5);
allfa = data(:,6);

subjvec = unique(allsubjid);
nsubj = length(subjvec);
Nvec = unique(alln);
data = [];
parest = NaN(nsubj,3);
prophi = NaN(nsubj,length(Nvec));
propfa = NaN(nsubj,length(Nvec));
for subjind = 1:nsubj
    subj = subjvec(subjind)
    fprintf('Subject %2.0f \n',subj)
    
    % Data formatting
    for Nind = 1:length(Nvec)
        N = Nvec(Nind);
        idx = find(allsubjid==subj & alln == N);
        data(Nind,1) = N;
        data(Nind,2) = sum(allhi(idx));
        data(Nind,3) = sum(allchange(idx)) - sum(allhi(idx));
        data(Nind,4) = sum(allfa(idx));
        data(Nind,5) = sum(allnochange(idx)) - sum(allfa(idx));
    end
    prophi(subjind,:) = data(:,2)./(data(:,2)+data(:,3));
    propfa(subjind,:) = data(:,4)./(data(:,4)+data(:,5));
    
    % Model fitting
    lb = zeros(1,3); % Lower bound for parameters
    [parest(subjind,:),FVAL,EXITFLAG] = patternsearch({@CDsimple_modelpred,data},[10 1 10],[],[],[],[],lb);
    [NLLmin phi(subjind,:) pfa(subjind,:)] = CDsimple_modelpred(parest(subjind,:), data);
    
end
delete('pars*')
xlswrite('pars',{'subject.no','J1bar','alpha','tau'},'A1:D1')
xlswrite('pars',[subjvec],strcat('A2:A',num2str(nsubj+1)))
xlswrite('pars',parest,strcat('B2:D',num2str(nsubj+1)))

% Plotting
figure; hold on;
fill([Nvec' Nvec(end:-1:1)'], [mean(phi,1)-std(phi,[],1)/sqrt(length(subjvec)) mean(phi(:,end:-1:1),1)+std(phi(:,end:-1:1),[],1)/sqrt(length(subjvec))],[1 .5 .5],'EdgeColor','None');
fill([Nvec' Nvec(end:-1:1)'], [mean(pfa,1)-std(pfa,[],1)/sqrt(length(subjvec)) mean(pfa(:,end:-1:1),1)+std(pfa(:,end:-1:1),[],1)/sqrt(length(subjvec))],[.5 .5 1],'EdgeColor','None');
errorbar(Nvec, nanmean(prophi,1),nanstd(prophi,[],1)/sqrt(length(subjvec)),'r.');
errorbar(Nvec, nanmean(propfa,1),nanstd(propfa,[],1)/sqrt(length(subjvec)),'b.');
xlim([min(Nvec)-0.5 max(Nvec)+0.5]);ylim([0 1]); xlabel('Set size'); ylabel('Proportion change reports'); title('Error bars: data. Shaded area: model fits')

figure;
subplot(1,2,1); hold on;
scatter(prophi(:), phi(:)); axis([0 1 0 1])
plot([0 1], [0 1], 'k--')
xlabel('Observed hit rate'); ylabel('Predicted hit rate')

subplot(1,2,2); hold on;
scatter(propfa(:), pfa(:)); axis([0 1 0 1])
plot([0 1], [0 1], 'k--')
xlabel('Observed false-alarm rate'); ylabel('Predicted false-alarm rate')