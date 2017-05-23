% 2-PAM with RC filter
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

%CREAZIONE DEL FILTRO 
x = rectpulse(ak,Ns);

df = 1/Nbits;

B = 3;

x = rectpulse(ak,Ns);

Ps = mean(x.^2);

X = fftshift(fft(x));

f = [-Ns/2:df:Ns/2-df];

H = 1./(1+(j*2*pi*f./B));

Y = X.*H.';
y = real(ifft(fftshift(Y)));

eyediagram(y(1:1000*Ns),2*Ns,2*Ns);

