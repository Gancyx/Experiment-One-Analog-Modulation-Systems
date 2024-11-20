clc; close all;
Tm=0.01; %符号周期Tm=1/Rb
fc=1000; %载波频率
N_sample=100; %每符号采样点个数
N_sum=1000; %符号个数
dt=Tm/N_sample;
N=N_sample*N_sum;
t=(0:dt:N_sum*Tm-dt)';
c=sin(2*pi*fc*t); %载波信号
NFFT=2.^16;
Nloop=50;
span = 5; %截断长度
alpha = 1; %滚降系数
st2=0; %矩形脉冲信号
st3=0; %滚降脉冲信号
for i =1:Nloop
    d = 2 * randi([0, 1], N_sum, 1) - 1; %产生双极性信号 'N_sum' 是要生成的随机整数矩阵的行数 '1' 是要生成的随机整数矩阵的列数
    st_bb=rectpulse(d,N_sample); %生成矩形波
    st_2psk=st_bb.*sin(2*pi*fc*t);
    h = (rcosdesign(alpha, span, N_sample)).*5; %冲激响应
    y = filter(h, 1, upsample(d, N_sample)); %对信号进行滤波处理，生成滚降脉冲波形
    st_rf=y.*sin(2*pi*fc*t);

    window=boxcar(length(st_bb)); %定义矩形窗
    [pxx2,~]=periodogram(st_2psk,window,NFFT,1/dt);
    [pxx3,f]=periodogram(st_rf,window,NFFT,1/dt);
     st2=st2+pxx2; st3=st3+pxx3;
end
st2=st2/Nloop;
st3=st3/Nloop;

%% 绘制波形
%矩形脉冲波形
figure('Position', [100, 100, 800, 600]);  % Adjust figure size as needed
subplot(411); 
plot(t,c); axis([0 0.04 -1.2 1.2]);
xlabel('时间t');ylabel('幅度');title('载波信号的时域波形');
subplot(412); 
plot(t,st_bb); axis([0 0.06 -1.2 1.2]);
xlabel('时间t'); ylabel('幅度') ;title('双极性基带信号的时域波形');
subplot(413); plot(t,st_2psk); axis([0 0.04 -1.2 1.2]);
xlabel('时间t'); ylabel('幅度') ;title('BPSK已调信号波形');
subplot(414); plot(f,st2.*10.^5); xlim([400 1600]); 
xlabel('频率f'); ylabel('幅度'); title('BPSK已调信号的频谱');

%滚降脉冲波形
figure('Position', [100, 100, 800, 600]);  % Adjust figure size as needed
subplot(3,1,1);
plot(t,y); axis([0 0.06 -1.2 1.2]); title('升余弦滚降系统的部分输出时域波形图');
subplot(3,1,2); 
plot(t,st_rf); axis([0 0.06 -1.2 1.2]); title('BPSK已调信号波形');
subplot(3,1,3);
plot(f,st3.*10.^5); title('BPSK已调信号的频谱'); xlim([400 1600]);
