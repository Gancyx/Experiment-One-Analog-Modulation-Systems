function n = generateNoise(EbN0_dB, d)
    Qm = 2; % 每符号比特数
    Es = mean(abs(d).^2);
    Eb = Es / Qm;
    
    ebn0 = 10.^(EbN0_dB/10); % 计算线性信噪比
    sigma = sqrt(Eb / ebn0 / 2);
    n = sigma * randn(size(d)) + 1i * sigma * randn(size(d)); % 生成噪声
end
