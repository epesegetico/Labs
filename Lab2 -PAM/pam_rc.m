% 2-PAM with RC filter - DA FINIRE
clear all
close all

Ns = 8;
Nbits = 1e6;  
N = Ns*Nbits;

Rin = randi([0 1],[Nbits, 1]);

ak = zeros(Nbits,1);


%Mapping dei valori

ak = 2*Rin-1;

x = rectpulse(ak,Ns);
Ps = mean(x.^2);
X = fftshift(fft(x));

%AWGN


EbNo = linspace(2,12,8);

sigma = (Ps*Ns/2)*10.^(-EbNo./10);

stdev = sigma.^(1/2);

R = stdev.*randn(N,1);



%CREAZIONE DEL FILTRO 

fp = 2.5;  % Studiare la variazione
df = 1/Nbits;
f = [-Ns/2:df:Ns/2-df];


H = 1./(1+(j*2*pi*f/fp));

%Convoluzione senza rumore e eye diagram

  Y = X.*H.';
  y = real(ifft(fftshift(Y)));  
  eyediagram(y(1:1000*Ns),2*Ns,2*Ns)
  pause


Vth = 0;
topt = 7+1;

for ii = 1:8
  
    
    xtx = x+R(:,ii);
   
    
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

    
    BER(ii) = errors/Nbits;
    
end

EbNolin = 10.^(EbNo./10);

BERth = 1/2 * erfc((EbNolin.^0.5) * (2/fp).^0.5 * (1-exp(-fp)));  %BER Teorico per 2-PAM con RC
BERthMF = 1/2 * erfc((EbNolin).^0.5); 

figure

semilogy(EbNo,BERth,'r-');
hold on
grid on
semilogy(EbNo,BER,'b*');
hold on
semilogy(EbNo,BERthMF,'b--');
xlabel('Eb/No [dB]');
ylabel('BER');
legend('RC filter','Simulated RC filter','Matched filter');
