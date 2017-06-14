clear all
close all

[signal,Fs] = audioread('sound.mp3');
%[signal,Fs] = audioread('voice.mp3');


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
grid on



signal = signal(:,1);
V = max(abs(signal));

figure
for n=4:2:8
    
   n
    
    M = 2^n;
    delta = (2*V)/M;
    
    init_codebook = [-V + delta/2:delta:V-delta/2];
    tic
    [partition,codebook] = lloyds(signal,init_codebook);
    toc
   
    [index,quantv] = quantiz(signal,partition,codebook);
    

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
        e = vout'-signal;
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
    title('PCM - Music sampled with Lloyd Algorithm');
    %title('PCM - Voice sampled with Lloyd Algorithm');
    legend('Music','Signal with uniform PDF');
    %legend('Voice','Signal with uniform PDF');
    
    
  
    
end








