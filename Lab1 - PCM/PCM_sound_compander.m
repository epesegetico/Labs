clear all
close all

%[signal,Fs] = audioread('sound.mp3');
[signal,Fs] = audioread('voice.mp3');

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

mu = 255;


signal = signal(:,1); 
V = max(abs(signal(:)));

sigout = compand(signal,mu,V,'mu/compressor');

figure
histogram(sigout,'NumBins',50,'Normalization','pdf');
axis([-2 2 0 5])


figure
histogram(sigout,'NumBins',50);
axis([-2 2 0 10e3])

pause
for n=4:2:8
    
   
    
    M = 2^n;
    delta = (2*V)/M;
    
    partition = [-V+delta:delta:V-delta];
    codebook = [-V + delta/2:delta:V-delta/2];
    
    [index,quantv] = quantiz(sigout,partition,codebook);
    

    %ENCODER
    b = de2bi(index,n);
    
    
    %BSC + DECODER
    
    Pb = logspace(-9,-1,9);
    for i = 1:1:length(Pb)
        i
        ndata = bsc(b,Pb(i));
        
        d = bi2de(ndata);
        
        %         subplot(2,5,i);
        %         plot(signal,codebook(d+1),'.');
        
     
        vout = codebook(d+1);
        sigfinal = compand(vout,mu,V,'mu/expander');
        
        e = sigfinal-signal';
        SNR(i) = 10*log10(var(signal)/var(e));
        
    end
    
    semilogx(Pb,SNR,'bo');
    hold on
    grid on
    
    
    Pbth = logspace(-9,-1,10000);
    
    SNRth = 10*log10((M^2)./(1+4*(M^2-1).*Pbth));
    semilogx(Pbth,SNRth,'r-');
    
    xlabel('Pb(e)');
    ylabel('SNR [dB]');
    title('SNR vs Pb(e) -  Music sampled with Compander');
    legend('Sound','Signal with uniform PDF');
    %legend('Voice','Signal with uniform PDF');
    
    
    hold on
   
    
    
end







