clc;       
clear;      
close all;

% ---- parameters ----
N = 1e5; %num of symbols
Es = 1;  %symbol energy

% 1.2.1 Symbol generation
% N symbols from the BPSK constellation with equal a priori
% probabilities P(+sqrt(Es)) = P(-sqrt(Es)) = 0.5

constellation = [sqrt(Es), -sqrt(Es)];  
priors = [0.5, 0.5];         % equal a priori probabilities

s = randsrc(1, N, [constellation; priors]);% Nx1 row of transmitted symbols


% debug
fprintf('Generated %d symbols\n', numel(s));
fprintf('Fraction +%.0f : %.4f\n', sqrt(Es), mean(s ==  sqrt(Es)));
fprintf('Fraction -%.0f : %.4f\n', sqrt(Es), mean(s == -sqrt(Es)));
% debug

% 1.2.2
% pass the transmitted symbols through the AWGN channel R_n = S_n + W_n
% where W_n ~ N(0, N0/2) and SNR = Es/N0
% implemented as the local function gaussian_channel (see bottom of file)


% 1.2.3
% for each SNR in [-6,6] dB, generate the received vector through the
% gaussian channel and decode it with the MAP rule

SNR_dB = -6:6; % 13 SNR points
SNR_lin = 10.^(SNR_dB/10); % convert to linear

s_hat_G = zeros(numel(SNR_lin),N); % decoded symbols

for k = 1:numel(SNR_lin)
    r_G = gaussian_channel(s,SNR_lin(k),Es); % received noisy vector
    s_hat_G(k,:) = sign(r_G);
end

% 1.2.4 
% error probability of the decoded stream (gaussian channel)
Pe_G = mean(s_hat_G~=s,2); % column vector one error probability per SNR

% 1.2.5
% plot the error probability vs SNR (gaussian channel)
figure;
plot(SNR_dB,Pe_G, '-o','DisplayName', 'Gaussian');
grid on;
xlabel('SNR per symbol [dB]');
ylabel('symbol error probability P_e');
title('BPSK error probability over the gaussian channel');
legend('show', 'Location', 'southwest');

% 1.2.6
% MAP decoding over the SNR sweep (Laplace channel)
s_hat_L = zeros(numel(SNR_lin), N);
for k = 1:numel(SNR_lin)
    r_L = laplace_channel(s, SNR_lin(k), Es);
    s_hat_L(k,:) = sign(r_L);  % MAP rule threshold at r = 0
end

% Error probability of the decoded stream
Pe_L = mean(s_hat_L ~= s, 2);  % one error probability per SNR

% Plot Pe vs SNR (Laplace channel)
figure;
plot(SNR_dB, Pe_L, '-s','DisplayName', 'Laplace');
grid on;
xlabel('SNR per symbol [dB]');
ylabel('Symbol error probability  P_e');
title('BPSK error probability over the Laplace channel');
legend('show', 'Location', 'southwest');


% 1.2.7
% gaussian vs laplace error probability on a single graph

figure;
plot(SNR_dB,Pe_G,'-o','Color','b','DisplayName', 'Gaussian');
hold on;
plot(SNR_dB,Pe_L,'-s','Color','r','DisplayName', 'Laplace');
hold off;
grid on;
xlabel('SNR per symbol [dB]');
ylabel('Symbol error probability P_e');
title('BPSK error probability Gaussian vs Laplace channel');
legend('show', 'Location', 'southwest');

% ===== functions =====

function r = gaussian_channel(s, SNR, Es)
% 1.2.2
% s: Nx1 vector of transmitted symbols
% SNR: SNR per symbol (NOT dB)
% Es: symbol energy
% r: Nx1 channal output noisy vector
    N0    = Es / SNR; % noise spectral density from SNR = Es/N0
    sigma = sqrt(N0 / 2); % std of each noise sample: var = N0/2
    w     = sigma * randn(size(s));   % gaussian noise N(0, N0/2)
    r     = s + w; % channel output
end

function r = laplace_channel(s, SNR, Es)
    % 1.2.6
    % laplace noise channel R = S + W, with W ~ Laplace(0, var = N0/2)
    % SNR = Es/N0  =>  N0 = Es/SNR  =>  var = N0/2 = Es/(2*SNR).
    % laprnd's 4th argument is the standard deviation, so sigma = sqrt(var)
    sigma = sqrt(Es / (2*SNR));
    w = laprnd(1, numel(s), 0, sigma);
    r = s + w;
end