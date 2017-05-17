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

Ns = 4;
Nbits = 1e3;

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


% AWGN


sigmaDB = zeros(8,1);
sigma = sigmaDB;

BER = sigma;
BERth = sigma;
EbNo = linspace(1,8,8);



h = rectpulse(abs(ak(1)),Ns);


for ii = 1:8
    sigma(ii) = (Ns/2)*10^(-ii/10);
    
    stdev(ii) = sqrt(sigma(ii));
    
    N = Nbits*Ns;
    
    R = stdev(ii)*randn(N,1);
    
    
    xtx = x+R;
    
    xrx = conv(xtx,h);
    
    %xnoiseless = conv(x,h,'valid');
    %ed = comm.EyeDiagram();
    %ed(xnoiseless);
    
    
    
    
    
    topt = Ns;
    
    
    
    
    y = xrx(topt:Ns:end);
    
    yfin = zeros(Nbits,1);
    Vth = 0;
    
    for jj=1:length(y)
        if y(jj)>Vth
            yfin(jj) = 1;
        else
            yfin(jj) = 0;
        end
    end
    
    
    errors = sum(abs(yfin-Rin));
    
    BER(ii) = errors/Nbits;
    BERth(ii) = 1/2*erfc(sqrt(Ns/(2*sigma(ii))));

    
end

semilogy(EbNo,BERth,'r-');
hold on
semilogy(EbNo,BER,'bo');


%Si osserva che col diminuire di Nbits il comportamento si discosta molto
%da quello teorico

%DA VERIFICARE LA FORMULA DEL BERth (Teorico)
