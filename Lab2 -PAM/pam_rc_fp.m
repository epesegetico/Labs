% 2-PAM with RC filter - DA FINIRE
clear all
close all

Ns = 24;
Nbits = 1e6;  
N = Ns*Nbits;
nbit = 1;

Rin = randi([0 1],[Nbits, 1]);

ak = zeros(Nbits,1);


%Mapping dei valori

ak = 2*Rin-1;

x = rectpulse(ak,Ns);
Ps = mean(abs(x).^2);
X = fftshift(fft(x));

%AWGN

EbNo = 8;
EbNolin = 10.^(EbNo./10);
sigma = (Ps*Ns)./(2*nbit*EbNolin); 


stdev = sigma.^(1/2);



%CREAZIONE DEL FILTRO 


df = 1/Nbits;
f = [-Ns/2:df:Ns/2-df];


H = 1./(1+(j*f./fp));

%Prodotto senza rumore e eye diagram

  Y = X.*H.';
  y = real(ifft(fftshift(Y)));  
  %eyediagram(y(1:1000*Ns),2*Ns,2*Ns)
  

  pause


Vth = 0;
topt = Ns;

fp = [0.1:0.1:1.5];

for counter = 1:length(fp)
    
    counter
    
    H = 1./(1+(j*f./fp(counter)));
for ii = 1:length(EbNo)
    noise = stdev(ii).*randn(N,1);
    xtx = x+noise(:);
    

    
    Xtx = fftshift(fft(xtx));
    
    %eyediagram(xrx(1:1000*Ns),2*Ns,2*Ns);
    
    
    Xrx = Xtx.*H.';
    
    xrx = real(ifft(fftshift(Xrx)));
     
    y = xrx(topt:Ns:end);  
    
    for jj = 1:1:length(y)
        if y(jj)>Vth
            y(jj) = 1;
        else
            y(jj) = 0;
        end
    end
    

    errors = sum(abs(y-Rin));

    
    
    
end
    
BER(counter) = errors/Nbits;

BERth(counter) = 1/2 * erfc((EbNolin(ii).^0.5) * (2/(2*pi*fp(counter))).^0.5 * (1-exp(-2*pi*fp(counter)))); 




end





%BERth = 1/2 * erfc((EbNolin.^0.5) * (2/(2*pi*fp)).^0.5 * (1-exp(-2*pi*fp)));  %BER Teorico per 2-PAM con RC



BERthMF = 1/2 * erfc((EbNolin).^0.5); 

figure
% 
semilogy(fp,BERth,'r-*');
hold on
grid on
semilogy(fp,BER,'b-*');
hold on

xlabel('fp');
ylabel('BER');
title('BER vs fp - Eb/No = 8 dB');
legend('RC filter','Simulated RC filter');



% cleanfigure();
% matlab2tikz('pam_rc_FP.tex');
