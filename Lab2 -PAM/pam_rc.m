% 2-PAM with RC filter - DA FINIRE
clear all
close all

Ns = 4;
Nbits = 1e6;  
N = Ns*Nbits;

Rin = randi([0 1],[Nbits, 1]);

ak = zeros(Nbits,1);


%Mapping dei valori

for ii = 1:length(Rin)
    if Rin(ii) == 0
        ak(ii) = -1;
    else
        ak(ii) = 1;
    end
end


x = rectpulse(ak,Ns);
Ps = mean(x.^2);
X = fftshift(fft(x));

%AWGN


EbNo = linspace(1,8,8);

sigma = (Ps*Ns/2)*10.^(-EbNo./10);

stdev = sigma.^(1/2);

R = stdev.*randn(N,1);



%CREAZIONE DEL FILTRO 

B = 2;  % Studiare la variazione
df = 1/Nbits;
f = [-Ns/2:df:Ns/2-df];


H = 1./(1+(j*2*pi*f./B));

%Convoluzione senza rumore e eye diagram

% Y = X.*H.';
% y = real(ifft(fftshift(Y)));
% 
% eyediagram(y(1:1000*Ns),2*Ns,2*Ns)
% pause


Vth = 0;
topt = Ns;

for ii = 1:8
  
    
    xtx = x+R(:,ii);
   
    
    Xtx = fftshift(fft(xtx));
    
    %eyediagram(xrx(1:1000*Ns),2*Ns,2*Ns);
    Xrx = Xtx.*H.';
    
    xrx = real(ifft(fftshift(Xrx)));
     
    y = xrx(2:topt:end);  
    
    for jj = 1:1:length(y)
        if y(jj)>Vth
            y(jj) = 1;
        else
            y(jj) = 0;
        end
    end
    

    errors = sum(abs(y-Rin));

    
    BER(ii) = errors/Nbits;
    
   
end

EbNolin = 10.^(EbNo./10);

BERth = 1/2 * erfc((EbNolin/2).^0.5);  %BER Teorico per 2-PAM con ILPF

semilogy(EbNo,BERth,'r-');
hold on
semilogy(EbNo,BER,'b*');

