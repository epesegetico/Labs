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

M = 2;
nbit = log2(M);

Ns = 8;
Nbits = 1e6;  
N = Nbits*Ns;

Rin = randi([0 1],[Nbits, 1]);

ak = zeros(Nbits,1);

%Mapping dei valori

ak = 2*Rin-1;

x = rectpulse(ak,Ns);

Ps = mean(abs(x).^2);

% AWGN


EbNo = linspace(1,8,8);
EbNolin = 10.^(EbNo./10);
sigma = (Ps*Ns)./(2*nbit*EbNolin); 

stdev = sigma.^(1/2);


%Filtro normalizzato

h = 1/Ns*rectpulse(1,Ns);


%Situazione senza rumore

xnoiseless = conv(x,h,'valid');
eyediagram(xnoiseless(1:1000*Ns),2*Ns,2*Ns)
pause 

Vth = 0;
topt = 1;

for ii = 1:length(EbNo)
    
    
    noise = stdev(ii).*randn(N,1);
    xtx = x+noise(:);
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



BERth = 1/2 * erfc(EbNolin.^0.5);  %BER Teorico per 2-PAM

semilogy(EbNo,BERth,'r-');
hold on
grid on
semilogy(EbNo,BER,'b*');
xlabel('Eb/No [dB]');
ylabel('SNR');
title('2-PAM Modulation with Matched Filter');
legend('Theorical Curve','Simulation');



%Si osserva che col diminuire di Nbits il comportamento si discosta molto
%da quello teorico


