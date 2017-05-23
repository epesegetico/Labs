clear all
close all


%2-PAM with ILPF

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

%CREAZIONE DEL FILTRO 
%Il filtro ideale va in frequenza da -B/2 a B/2 -> B è variabile
%L'asse delle frequenze va da -Bsim/2 a Bsim/2
%Bsim = Ns*Rs -> Poiché normalizziamo,Bsim/Rs = Ns
%df = Ns/(Ns*Nbit) = 1/Nbit


df = 1/Nbits;

B = 1;

x = rectpulse(ak,Ns);

Ps = mean(x.^2);

X = fftshift(fft(x));

f = [-Ns/2:df:Ns/2-df];

H = abs(f)<B;

%Situazione senza rumore

Y = X.*H.';
y = real(ifft(fftshift((Y))));
%eyediagram(y(1:1000*Ns),2*Ns,2*Ns);

%pause

EbNo = linspace(1,8,8);
sigma = zeros(8,1);
stdev = sigma;



for ii = 1:8
    
    
    
    sigma(ii) = (Ps*Ns/2)*10^(-EbNo(ii)/10);
    stdev(ii) = sqrt(sigma(ii));
    
    
    
    R = stdev(ii)*randn(N,1);
    
    
    xtx = x+R;
    
    %valid o non valid??
    
    Xtx = fftshift(fft(xtx));
    
    %eyediagram(xrx(1:1000*Ns),2*Ns,2*Ns);
    Xrx = Xtx.*H.';
    
    xrx = real(ifft(fftshift(Xrx)));
    
    
    topt = Ns;
    
    
    
    
    y = xrx(2:topt:end);
    
    
    yfin = zeros(Nbits,1);

    
    Vth = 0;
    
    for jj = 1:1:length(y)
        if y(jj)>Vth
            yfin(jj) = 1;
        else
            yfin(jj) = 0;
        end
    end
    

    errors = sum(abs(yfin-Rin));

    
    BER(ii) = errors/Nbits;
    
   
end

EbNolin = 10.^(EbNo./10);

BERth = 1/2 * erfc((EbNolin/2).^0.5);  %BER Teorico per 2-PAM con ILPF

semilogy(EbNo,BERth,'r-');
hold on
semilogy(EbNo,BER,'b*');


