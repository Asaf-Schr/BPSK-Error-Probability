clc;       
clear;      
close all;

% ---- parameters ----
N = 1e5; %num of symbols
Es = 1;  %symbol energy

%% 1.2.1 — Symbol generation
% Generate N symbols from the BPSK constellation with equal a priori
% probabilities P(+sqrt(Es)) = P(-sqrt(Es)) = 0.5

constellation = [sqrt(Es), -sqrt(Es)];  
priors = [0.5, 0.5];                     % equal a priori probabilities

s = randsrc(1, N, [constellation; priors]);   % 1 by N row of transmitted symbols


% debug
% ---- Sanity check (not part of the deliverable, but useful) ----
fprintf('Generated %d symbols\n', numel(s));
fprintf('Fraction +%.0f : %.4f\n', sqrt(Es), mean(s ==  sqrt(Es)));
fprintf('Fraction -%.0f : %.4f\n', sqrt(Es), mean(s == -sqrt(Es)));
% debug


