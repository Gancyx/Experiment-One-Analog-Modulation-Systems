clear; close all; clc;
%% 绘制不同噪声功率下的QPSK星座图
Qm = 2; % 每符号比特数
N_num = 10^5; % 仿真符号数

d1 = sign(randn(1, N_num));
d2 = sign(randn(1, N_num));
d = d1 + 1i * d2;

% n=generateNoise(定义对数信噪比,比特值);
n1 = generateNoise(30, d); % 调用函数生成噪声
n2 = generateNoise(20, d); 
n3 = generateNoise(10, d); 
n4 = generateNoise(5, d); 

rt1 = d + n1; % 加噪
rt2 = d + n2; rt3 = d + n3; rt4 = d + n4;
figure;
subplot(2,2,1);
plot(rt1, '.'); xlabel('In-phase'); ylabel('Quadrature'); 
title('SNR=30dB');
subplot(2,2,2);
plot(rt2, '.'); xlabel('In-phase'); ylabel('Quadrature'); 
title('SNR=20dB');
subplot(2,2,3);
plot(rt3, '.'); xlabel('In-phase'); ylabel('Quadrature'); 
title('SNR=10dB');
subplot(2,2,4);
plot(rt4, '.'); xlabel('In-phase'); ylabel('Quadrature'); 
title('SNR=5dB');

%% 下面为定义的函数部分
% function n = generateNoise(EbN0_dB, d)
%     Qm = 2; % 每符号比特数
%     Es = mean(abs(d).^2);
%     Eb = Es / Qm;
% 
%     ebn0 = 10.^(EbN0_dB/10); % 计算线性信噪比
%     sigma = sqrt(Eb / ebn0 / 2);
%     n = sigma * randn(size(d)) + 1i * sigma * randn(size(d)); % 生成噪声
% end
