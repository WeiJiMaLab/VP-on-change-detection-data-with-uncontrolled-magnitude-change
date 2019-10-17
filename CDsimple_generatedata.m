function data = CDsimple_generatedata(J1bar, alpha, tau, Nvec, Ntrials)
% Weiji Ma, 20140601

Ndata = Nvec(randi(length(Nvec), Ntrials, 1))';
Cdata = randi(2,Ntrials,1)-1;

nhi = NaN(1,length(Nvec));
nmi = NaN(1,length(Nvec));
nfa = NaN(1,length(Nvec));
ncr = NaN(1,length(Nvec));

for Nind = 1:length(Nvec)
    N = Nvec(Nind);
    idx = find(Ndata==N);    
    J = gamrnd(J1bar * N^-alpha/tau, tau, length(idx), N);   % Precision values on this trial
    x = randn(length(idx),N)./sqrt(J);                      % Measurement noise
    x(:,1)= x(:,1) + Cdata(idx);                            % Add 1 to each target    
    decision = mean(exp((x-0.5).*J),2)>1;
    nhi(Nind) = sum(Cdata(idx)==1 & decision==1);
    nmi(Nind) = sum(Cdata(idx)==1 & decision==0);
    nfa(Nind) = sum(Cdata(idx)==0 & decision==1);
    ncr(Nind) = sum(Cdata(idx)==0 & decision==0);
end

data = [Nvec; nhi+nmi; nhi; nfa+ncr; nfa]';