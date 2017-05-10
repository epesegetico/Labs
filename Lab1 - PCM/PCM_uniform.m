% QUANTIZER
% quantiz is the generic quantizer - i have to set +V and -V
% to avoid clipping. [index,quants] = quantiz(sig,partition,codebook)
% the codebook in the case of the uniform quantizer is the array
% with the middle value of the intervals (TEST THIS)

% ENCODER
% b = de2bi(d,n) - convert index to binary

% BSC
% ndata = bsc(data,p) - p is the error probability
% one can write his own - remember that errors are randomly distributed
% see slide 7

% DECODER
% d = bi2de(b) - decimal to binary
% AFTER THIS WE HAVE <<Vout SAMPLED>>

% SIGNAL TO NOISE
% e = Vout-Vin - S/N has the usual definition
% Plot for different M the theoretical pcm performance

% COMPANDER
% Use the u-Law

% NON UNIFORM QUANTIZATION
% [partition,codebook] = lloyds(training_set,initcodebook)
% training_set is a portion of the signal (heavy to be loaded with large
% samples). Initial codebook can be the uniform partition


close all
clear



V = 8;
    
    N = 5000000;
    
    signal = -V + (2*V).*rand(N,1);
    
    histogram(signal,'NumBins',50,'BinLimits',[-V V],'Normalization','pdf');
    axis([-10 10 0 0.1])
    grid on
    
    

    
for n=4:2:8
    
   
    
    M = 2^n;
    delta = (2*V)/M;
    
    partition = [-V+delta:delta:V-delta];
    codebook = [-V + delta/2:delta:V-delta/2];
    
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
        e = vout-signal';
        SNR(i) = 10*log10(var(signal)/var(e));
        
    end
    
    semilogx(Pb,SNR,'bo');
    hold on
    grid on
    
    
    Pbth = logspace(-9,-1,10000);
    
    SNRth = 10*log10((M^2)./(1+4*(M^2-1).*Pbth));
    semilogx(Pbth,SNRth,'r-');
    pause
end






