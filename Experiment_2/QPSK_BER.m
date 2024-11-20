%% 计算QPSK的误码率性能
M = 4; % QPSK
numBits = 1e6; % 生成的随机二进制位数
EbN0_dB = 0:10; % Eb/N0范围

% 生成随机二进制位
data = randi([0 1], numBits, 1);

% QPSK映射
dataEnc = bi2de(reshape(data, [], log2(M)));
symbols = pskmod(dataEnc, M);

% 计算符号功率和比特功率
Es = mean(abs(symbols).^2);
Eb = Es/log2(M);

% 初始化BER数组
berSim = zeros(size(EbN0_dB));

% 对每个Eb/N0值进行模拟
for i = 1:length(EbN0_dB)
    % 生成高斯噪声
    n0 = Eb / (10^(EbN0_dB(i)/10));
    noise = sqrt(n0/2) * (randn(size(symbols)) + 1j*randn(size(symbols)));
    
    % 添加噪声并进行最优决策
    received = symbols + noise;
    dataDec = pskdemod(received, M);
    
    % 计算误比特率（BER）
    [~, berSim(i)] = biterr(dataEnc, dataDec);
end

% 计算理论BER
berTheory = berawgn(EbN0_dB, 'psk', M, 'nondiff');

% 比较模拟结果和理论BER曲线
semilogy(EbN0_dB, berSim, 'o-');
hold on;
semilogy(EbN0_dB, berTheory);
grid on;
legend('仿真值', '理论值');
xlabel('Eb/N0 (dB)');
ylabel('BER');
title('QPSK的BER性能');
