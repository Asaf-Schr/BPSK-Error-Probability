clc;       
clear;      
close all;

% ---- parameters ----
N = 1e5; %num of symbols
Es = 1;  %symbol energy

%% 1.2.1 Symbol generation
% N symbols from the BPSK constellation with equal a priori
% probabilities P(+sqrt(Es)) = P(-sqrt(Es)) = 0.5

constellation = [sqrt(Es), -sqrt(Es)];  
priors = [0.5, 0.5];         % equal a priori probabilities

s = randsrc(1, N, [constellation; priors]);   % Nx1 row of transmitted symbols


% debug
fprintf('Generated %d symbols\n', numel(s));
fprintf('Fraction +%.0f : %.4f\n', sqrt(Es), mean(s ==  sqrt(Es)));
fprintf('Fraction -%.0f : %.4f\n', sqrt(Es), mean(s == -sqrt(Es)));
% debug

%% 1.2.2
% pass the transmitted symbols through the AWGN channel R_n = S_n + W_n
% where W_n ~ N(0, N0/2) and SNR = Es/N0

SNR_test = 4; %debug
r = gaussian_channel(s,SNR_test,Es); % channel output
%debug
w_emp        = r - s;                       % recover the noise realization
var_emp      = var(w_emp);
var_theory   = Es / (2 * SNR_test);
fprintf('Noise variance empirical: %.5f, theoretical: %.5f\n', ...
        var_emp, var_theory);
%debug












%% ===== functions =====

function r = gaussian_channel(s, SNR, Es)
% gaussian channel simulate the discrete time AWGN channel R_n = S_n + W_n
% r = gaussian_channel(s, SNR, Es) adds zero mean Gaussian noise to the
% transmitted symbols s
%
% s: Nx1 vector of transmitted symbols
% SNR: SNR per symbol (NOT dB)
% Es: symbol energy
% r: Nx1 channal output noisy vector

    N0    = Es / SNR; % noise spectral density from SNR = Es/N0
    sigma = sqrt(N0 / 2); % std of each noise sample: var = N0/2
    w     = sigma * randn(size(s));   % gaussian noise N(0, N0/2)
    r     = s + w; % channel output
end
