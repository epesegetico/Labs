% LAB 2 - PAM

%PATTERN GENERATOR

%Driver v(t) = sommatoria(ak*s(t-kTs)) - WRITE CODE
%ak depends whether we want antipodal or unipolar


%AWGN


%Keep Eb fixed, change N0 ( that is changing the sigma of the proces)
%Set sigma so that Eb/N0 = 2dB,3dB,... and then calculate Rch
%BER = 10*log10(var(sig_in)/(var(n)/Bsim))

%Ns is the number of bits per signal
%Sigma is the standard deviation
%Generation of white noise


%----RECEIVER---

%FILTER

%Matched filter - rectangular signal -> h(t) = s(t).
%y(t) = conv(x,h); LOOK AT THE HELP - "VALID FLAG" to discard zero-padding
%at the beginning and at the end

%In frequency
%1) fft to get X(f) -> fftshift(X(f))
%2) Y(f) = X(f).*H(f)
%3) ifft(Y(f))

%SAMPLING
%Given y(t) -> the sample can be obtained as sampled = y(1:Ns:end);
%Which is the optimum sample?
%a) from the eye diagram - y(topt:Ns:end);
%b) bruteforce approach - try all possible Ns sampling instant in a for
%   cycle

%DECISION TRESHOLD
%Explained in theory

%ERROR COUNTING
%Compare TX and RX signals -> sum(abs(bitsRX - bitsTX)) because 0 = correct
%bits, 1 = wrong.
%BER = #errors/#bits

%BE CAREFUL WITH THE ALIGNMENT OF THE VECTORS

%HOW MANY BITS SHOULD I SIMULATE? #errors = BER*#bits -> i should see the
%errors,so 10-100 errors minimum
close all
clear all

Ns = 8;
Nbits = 1e6;  

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

% AWGN


sigmaDB = zeros(8,1);
sigma = sigmaDB;

BER = zeros(8,1);
BERth = sigma;

EbNo = linspace(1,8,8);

%Filtro normalizzato

h = 1/Ns*rectpulse(1,Ns);

N = Nbits*Ns;

xnoiseless = conv(x,h,'valid');

%eyediagram(xnoiseless(1:1000*Ns),2*Ns,2*Ns)
%pause 

for ii = 1:8
    
    
    
    sigma(ii) = (Ps*Ns/2)*10^(-EbNo(ii)/10);
    stdev(ii) = sqrt(sigma(ii));
    
    
    
    R = stdev(ii)*randn(N,1);
    
    
    xtx = x+R;
    
    %valid o non valid??
    
    xrx = conv(xtx,h,'valid');
    
    %eyediagram(xrx(1:1000*Ns),2*Ns,2*Ns);
   
    
    topt = Ns;
    
    
    
    y = xrx(1:topt:end);
    
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

BERth = 1/2 * erfc(EbNolin.^0.5);  %BER Teorico per 2-PAM

semilogy(EbNo,BERth,'r-');
hold on
semilogy(EbNo,BER,'b*');


%Si osserva che col diminuire di Nbits il comportamento si discosta molto
%da quello teorico

