clear all
close all


%2-PAM with ILPF

Ns = 8;
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

EbNo = linspace(1,8,8);
EbNolin = 10.^(EbNo./10);
sigma = (Ps*Ns)./(2*nbit*EbNolin); 


stdev = sigma.^(1/2);



%CREAZIONE DEL FILTRO 
%Il filtro ideale va in frequenza da -B/2 a B/2 -> B è variabile
%L'asse delle frequenze va da -Bsim/2 a Bsim/2
%Bsim = Ns*Rs -> Poiché normalizziamo,Bsim/Rs = Ns
%df = Ns/(Ns*Nbit) = 1/Nbit

df = 1/Nbits;

B = 1;  %Scegliere valore
f = [-Ns/2:df:Ns/2-df]';
H = abs(f)<B;



%Situazione senza rumore

Y = X.*H;
y = real(ifft(fftshift((Y))));
eyediagram(y(1:1000*Ns),2*Ns,2*Ns);


cleanfigure();
matlab2tikz('pam_ilpf_EYE.tex');


pause

topt = 6;
Vth = 0;

for ii = 1:length(EbNo)
    
    noise = stdev(ii).*randn(N,1);
    xtx = x+noise(:);
   
   
    
    Xtx = fftshift(fft(xtx));
    
    %eyediagram(xrx(1:1000*Ns),2*Ns,2*Ns);
    Xrx = Xtx.*H;
    
    
    xrx = real(ifft(fftshift(Xrx)));
        
    
    
    y = xrx(topt:Ns:end);  
    
    %Decision Treshold
    
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


BERth = 1/2 * erfc((EbNolin/(2*B)).^0.5);  %BER Teorico per 2-PAM con ILPF
BERthMF = 1/2 * erfc((EbNolin).^0.5); 
semilogy(EbNo,BERth,'r-');
hold on
grid on
xlabel('Eb/No [dB]');
ylabel('BER');
title('2-PAM Modulation with Ideal Low Pass Filter');
semilogy(EbNo,BER,'b*');
semilogy(EbNo,BERthMF,'b--');
legend('ILPF theorical','ILPF simulation','Matched filter','Location','southwest');


cleanfigure();
matlab2tikz('pam_ilpf_BER.tex');


