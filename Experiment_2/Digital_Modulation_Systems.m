%% BPSK信号的矩形脉冲和滚降脉冲
clc; close all;
Tm=0.01; %符号周期Tm=1/Rb
fc=1000; %载波频率
N_sample=50; %每符号采样点个数
N_sum=200; %符号个数
dt=Tm/N_sample;
N=N_sample*N_sum;
t=(0:dt:N_sum*Tm-dt)';
c=sin(2*pi*fc*t); %载波信号
NFFT=2.^16;
Nloop=10;
a = 1;  % 滚降因子
st1=0; 
st2=0; %矩形信号
for i =1:Nloop
    d = 2 * randi([0, 1], N_sum, 1) - 1; %产生双极性信号 'N_sum' 是要生成的随机整数矩阵的行数 '1' 是要生成的随机整数矩阵的列数
    st_bb=rectpulse(d,N_sample); %生成矩形波
    st_2psk=st_bb.*sin(2*pi*fc*t);

    window=boxcar(length(st_bb)); %定义矩形窗
    [pxx1,~]=periodogram(st_bb,window,NFFT,1/dt);
    [pxx2,f]=periodogram(st_2psk,window,NFFT,1/dt);
    st1 = st1+pxx1; st2=st2+pxx2;
end

st1=st1/Nloop;
st2=st2/Nloop;
st3=st3/Nloop;

figure;
subplot(2,2,1); 
plot(t,c); axis([0 0.04 -1.2 1.2]);
xlabel('时间t');ylabel('幅度');title('载波信号的时域波形')
subplot(2,2,2); 
plot(t,st_bb); axis([0 0.06 -1.2 1.2]);
xlabel('时间t'); ylabel('幅度') ;title('双极性基带信号的时域波形');
subplot(2,2,3); plot(t,st_2psk); axis([0 0.06 -1.2 1.2]);
xlabel('时间t'); ylabel('幅度') ;title('BPSK已调信号波形');
subplot(2,2,4); plot(f,st2.*10.^5); xlim([400 1600]); 
xlabel('频率f'); ylabel('幅度'); title('BPSK已调信号的频谱');
figure;
stem(d, '.');
axis([0 50 -1.5 1.5]);
grid on;
title('随机双极性信号');

