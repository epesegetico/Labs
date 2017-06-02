%2-PAM with t^k filter

close all
clear all

Ns = 8;
Nbits = 1e6;  
N = Ns*Nbits;

Rin = randi([0 1],[Nbits, 1]);


%Mapping dei valori

ak = 2*Rin-1;

x = rectpulse(ak,Ns);
Ps = mean(x.^2);



k = 1;

h = [1:1:Ns].^k;

h = h/sum(h);

y = conv(x,h,'valid');

eyediagram(y(1:1000*Ns),2*Ns,2*Ns);

figure


%AWGN

EbNo = linspace(2,12,8);
EbNolin = 10.^(EbNo./10);
sigma = (Ps*Ns/2)*10.^(-EbNo./10);

stdev = sigma.^(1/2);

R = stdev.*randn(N,1);

topt = 1;
Vth = 0;


for ii = 1:length(EbNo)
    
    
    xtx = x+R(:,ii);
    xrx = conv(xtx,h,'valid');
    
    %eyediagram(xrx(1:1000*Ns),2*Ns,2*Ns);
   
      
    y = xrx(topt:Ns:end);
    
    for jj = 1:length(y)
        if y(jj)>Vth
            y(jj) = 1;
        else
            y(jj) = 0;
        end
    end
    

    errors = sum(abs(y-Rin));

    
    BER(ii) = errors/Nbits;
    
   
end

A = (2*k+1)/((k+1)^2);
BERth = 1/2*erfc((A.*EbNolin).^0.5);
BERthMF = 1/2*erfc((EbNolin).^0.5);

semilogy(EbNo,BERth,'r-');
hold on
grid on
xlabel('EbNo [dB]');
ylabel('SNR');
title('2-PAM with h(t) = t^k , k = 2, 12 samples/bit');    

semilogy(EbNo,BER,'b*');
semilogy(EbNo,BERthMF,'b--');

legend('t^k simulated','t^k filter','Matched filter');
