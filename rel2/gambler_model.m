clear all
close all
clc

maxMoney = 100; % money to reach

S = maxMoney + 1; % number of possible states
A = maxMoney - 1; % number of possible actions

%% probability transition matrices
P = zeros(S, S, A);

for si = 2:S-1 % we skip first and last state as they are absorbing 

    sstart = si - 1; % sstart represents the money the gambler has
    
    for a = 1:A % a represents how much money the gambler stakes
        bet = min(a, sstart);
        swin = min(sstart + bet, maxMoney);
        sloss = sstart - bet;
        P(sstart+1, swin+1, a) = 0.5;
        P(sstart+1, sloss+1, a) = 0.5;
    end
end

P(1, 1, :) = 1; % First state is absorbing
P(S, S, :) = 1; % Last state is absobring 

%% reward matrix
R = zeros(S,A);

for s = 2:S-1
    for a = 1:A
        R(s,a) = (-1) * P(s,1,a) + (1) * P(s,S,a);
    end
end

%%
save gambler_model.mat S A P R
