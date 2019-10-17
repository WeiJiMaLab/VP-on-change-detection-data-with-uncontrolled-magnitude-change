function [NLL, phi, pfa] = CDsimple_modelpred(pars, data)
% Weiji Ma, 20140601

J1bar = pars(1);    % Mean precision at set size 1; typically in range 10-100
alpha = pars(2);    % Power in dependence of mean precision on set size
tau = pars(3);      % Scale parameter of precision distribution

Nvec = data(:,1);
nhi = data(:,2);
nmi = data(:,3);
nfa = data(:,4);
ncr = data(:,5);

Tvec = [0 1];
Ntrials = 5000;     % Number of simulated trials used to construct the model predictions; unrelated to number of experimental trials

% Computing the predictions of the model for the probability of reporting a
% change in each of the (N,T) conditions
Phi = NaN(1,length(Nvec));
Pfa = NaN(1,length(Nvec));

for Nind = 1:length(Nvec)
    N = Nvec(Nind);
    Jbar = J1bar * N^-alpha;
    
    for Tind = 1:length(Tvec)
        T = Tvec(Tind);
        
        J = gamrnd(Jbar/tau, tau, Ntrials,N);
        x = randn(Ntrials,N)./sqrt(J);
        x(:,1) = x(:,1) + T; % adding 1 for every target
        decision = mean(exp((x-0.5).*J),2)>1;
        
        if T==0
            pfa(Nind) = min(1-1/Ntrials, max(1/Ntrials,mean(decision==1)));
        elseif T==1
            phi(Nind) = min(1-1/Ntrials, max(1/Ntrials,mean(decision==1)));
        end
    end
end
LL =  sum(nhi .* log(phi')) + sum(nmi .* log(1-phi'))+ ...
    + sum(nfa .* log(pfa')) + sum(ncr .* log(1-pfa'));

NLL = -LL; % negative log likelihood of the parameters