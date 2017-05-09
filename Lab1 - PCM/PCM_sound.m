clear all
close all

[signal,Fs] = audioread('sound.mp3');

histogram(signal(:,1),'NumBins',100,'Normalization','pdf');
axis([-2 2 0 5])
grid on

figure
histogram(signal(:,1));

%fft


N = length(signal);
Ts = 1/Fs;
t = [0:1:N-1]*Ts;
df = 1/Ts/N;  %equivale a Fs/N
f = [-N/2:1:N/2-1]*df;



S=abs(fftshift(fft(signal(:,1)))).^2;

figure
plot(f,S);
axis([0 5000 min(S) max(S)])

%sound(signal,fs);




