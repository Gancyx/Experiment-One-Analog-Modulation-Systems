%% DSB信号的调制
clear; clc;
Ac=1; % 载波振幅
Am=1; % 信号振幅
f_c=10000; % 载波频率
f_m=1000; % 信号频率
fs = 10.*f_c; % 采样频率
t=0:1/fs:0.01; % 时间范围
m=Am.*cos(2*pi.*f_m.*t); % 调制信号
c=Ac.*cos(2*pi.*f_c.*t); % 载波信号
uDSB=m.*c; % DSB已调信号

% 计算包络线
envelope = abs(hilbert(uDSB));

% 绘制时域信号
figure(1);
subplot(3,1,1);
plot(t,m);
title('调制信号');
subplot(3,1,2);
plot(t,c);
title('载波信号');
subplot(3,1,3);
plot(t,uDSB);
hold on;
plot(t,envelope,'r--','LineWidth',1.0); % 添加上包络线
plot(t,-envelope,'r--','LineWidth',1.0); % 添加下包络线
hold off;
title('DSB已调信号及其包络');

%% DSB调制信号的频谱
% 定义FFT长度
N = 2048;

M=fftshift(fft(m,N));
C=fftshift(fft(c,N));
UDSB=fftshift(fft(uDSB,N));

f=(0:N-1)*fs/N;
f=f-fs/2;
figure(2);
subplot(3,1,1);
plot(f,abs(M));xlabel('f');xlim([0 15000]);title('调制信号的频谱图');
subplot(3,1,2);
plot(f,abs(C));xlabel('f');xlim([0 22000]);title('载波信号的频谱图');
subplot(3,1,3);
plot(f,abs(UDSB));xlabel('f');xlim([0 22000]);title('已调信号的频谱图');

%% DSB已调信号的相干解调，与本地载波相乘
s=uDSB.*c;
S=fftshift(fft(s,N));
figure;
subplot(2,1,1);
plot(t,s);xlim([0,0.01]);xlabel('t');grid on; title('与载波相乘后的时域波形图');
subplot(2,1,2);
plot(f,abs(S));xlim([0,25000]);xlabel('f');grid on; title('与载波相乘后的频谱图');

%% 设计低通滤波器滤除高频分量，得到解调信号
wc=1.5*2*f_m/fs;
B=fir1(32,wc);
% figure;
% freqz(B,1,N,fs);

%% 再通过低通滤波器，恢复原信号
[h, w]=freqz(B, 1, N);
so=filter(B,1,s);
SO=fftshift(fft(so,N));
figure;
plot(w*fs/(2*pi),20*log10(abs(h)));grid on;
title('低通滤波器的频率响应图');
figure;
subplot(211);
plot(t,so);xlim([0 0.01]);xlabel('t');grid on; title('解调器输出信号的时域波形图');
subplot(212);
plot(f,abs(SO));xlabel('f');axis([0 22000 0 130]);grid on;title('解调器输出信号的频谱图');

%% 在解调载波中引入相位差
pd1=pi/8; pd2=pi/4; pd3=pi/3; pd4=pi/2; % Choose a phase difference in degrees
c_demod1 = uDSB.*cos(2*pi*f_c*t + pd1); % Asynchronous carrier for demodulation
c_demod2 = uDSB.*cos(2*pi*f_c*t + pd2);
c_demod3 = uDSB.*cos(2*pi*f_c*t + pd3);
c_demod4 = uDSB.*cos(2*pi*f_c*t + pd4);
% 通过低通滤波器恢复原始信号
% 在这里使用之前定义的低通滤波器 B 对解调信号进行处理
so1 = filter(B, 1, c_demod1);
so2 = filter(B, 1, c_demod2);
so3 = filter(B, 1, c_demod3);
so4 = filter(B, 1, c_demod4);

% 绘制已解调信号通过低通滤波器后的结果
figure;
subplot(2,2,1);
plot(t, so1); axis([0 0.01 -0.5 0.5]);xlabel('t'); grid on; title('Phase Diff. is $\pi/8$', 'Interpreter', 'latex');
subplot(2,2,2);
plot(t, so2); axis([0 0.01 -0.5 0.5]);xlabel('t'); grid on; title('Phase Diff. is $\pi/4$', 'Interpreter', 'latex');
subplot(2,2,3);
plot(t, so3);axis([0 0.01 -0.5 0.5]); xlabel('t'); grid on; title('Phase Diff. is $\pi/3$', 'Interpreter', 'latex');
subplot(2,2,4);
plot(t, so4);axis([0 0.01 -0.5 0.5]); xlabel('t'); grid on; title('Phase Diff. is $\pi/2$', 'Interpreter', 'latex');

%% 绘制AM和SSB调制的时域波形
A =1;
s_am=(A+m).*c;
s_ssb=filter(B,1,uDSB); %DSB信号通过滤波器，产生SSB信号

% 计算包络线
envelope = abs(hilbert(s_am));
figure;
subplot(211);
plot(t,s_am);xlabel('t');grid on; title('AM信号的时域图');
hold on;
plot(t,envelope,'r--','LineWidth',1.0); % 添加上包络线
plot(t,-envelope,'r--','LineWidth',1.0); % 添加下包络线
hold off;
subplot(212);
plot(t,s_ssb);xlim([0.005 0.01]);xlabel('t');grid on; title('下边带信号的时域图');

