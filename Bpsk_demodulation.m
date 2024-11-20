%% BPSK的解调
clear;close all;
fm=100;
Tm=1/fm;
fc=1000; %载波频率
N_sample = 20000; 
N_sum=100; %符号个数
dt=Tm/N_sample;
N=N_sample*N_sum;
t=(0:dt:N_sum*Tm-dt)';
c=sin(2*pi*fc*t); %载波信号
NFFT=2.^16;
d = 2 * randi([0, 1], N_sum, 1) - 1;
span = 5; %截断长度
alpha = 1; %滚降系数

%对于矩形脉冲
st_bb=rectpulse(d,N_sample); %产生基带信号
st_2psk=st_bb.*sin(2*pi*fc*t);
% % 对于滚降脉冲
% h = (rcosdesign(alpha, span, N_sample)).*5; %冲激响应
% y = filter(h, 1, upsample(d, N_sample)); %对信号进行滤波处理，生成滚降脉冲波形
% st_rf=y.*sin(2*pi*fc*t);

%% 在信道中进行传输
%如果进行滚降脉冲波形的分析的话，st2_2pskin=st_rf
st2_2pskin = st_2psk; %假设没有信道噪声的情况下，调制信号的输出等于解调信号的输入
wc1=[2*pi*(fc-fm)/N_sample,2*pi*(fc+fm)/N_sample];
B1 = fir1(256,wc1/pi);
st_out0=filter(B1,1,st2_2pskin); %通过带通滤波器

st_out1=st_out0.*sin(2*pi*fc*t); %与相干载波相乘
wc2 = 2*2*pi*fm/N_sample;
wc2=wc2/100;
B2 = fir1(2000,wc2/pi);
st_out2 = filter(B2,1,st_out1); %通过低通滤波器

% 进行抽样判决
threshold = 0; % 设置一个阈值，根据信号特性调整阈值
received_bits = zeros(N_sum, 1); % 初始化接收到的比特流

for i = 1:N_sum
    sample_index = (i - 1) * N_sample + 1; % 计算当前符号的起始抽样位置
    sample = st_out2(sample_index); % 对解调后的信号进行抽样

    % 根据信号的正负来判断是哪个比特值
    if sample < threshold
        received_bits((i - 1) * N_sample + 1 : i * N_sample) = ones(N_sample, 1);
    else
        received_bits((i - 1) * N_sample + 1 : i * N_sample) = zeros(N_sample, 1);
    end
end
%% 图像绘制
figure;
plot(t,st_bb); axis([0 0.2 -1.2 1.2]);
xlabel('时间t'); ylabel('幅度') ;title('双极性基带信号的时域波形');
%矩形脉冲波形分析
figure('Position', [100, 100, 800, 600]);  % Adjust figure size as needed
%sgtitle('矩形脉冲波形分析');
sgtitle('滚降脉冲波形分析');
subplot(2,2,1); plot(t,st_out1);
xlabel('时间t');ylabel('幅度');xlim([0 0.08]);
title('与载波相乘后输出的时域波形');

subplot(2,2,2); plot(t,st_out2);
xlabel('时间t');ylabel('幅度');xlim([0 0.2]);
title('低通滤波器后输出的时域波形');

subplot(2,2,3); plot(t,st_out0);
xlabel('时间t');ylabel('幅度');xlim([0 0.2]);
title('带通滤波器后输出的时域波形');

% 重新定义时间向量，使其长度与 received_bits 匹配
t_received_bits = (0:dt:N_sum * Tm - dt)';
subplot(2,2,4); plot(t_received_bits, received_bits);
xlabel('时间t');ylabel('幅度'); axis([0 0.2 -0.2 1.2]);
title('抽样判决后的信号');

fvtool(B1,1); % 带通滤波器的频率响应 
%fvtool(B2,1); %低通滤波器的频率响应
