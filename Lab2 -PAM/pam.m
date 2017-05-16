% LAB 2 - PAM

%PATTERN GENERATOR

%Driver v(t) = sommatoria(ak*s(t-kTs)) - WRITE CODE
%ak depends whether we want antipodal or unipolar


%AWGN


%Keep Eb fixed, change N0 ( that is changing the sigma of the proces)
%Set sigma so that Eb/N0 = 2dB,3dB,... and then calculate Rch
%10*log10(var(sig_in)/(var(n)/Bsim))

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


Ns = 8;
Nbits = 1e-6;

R = randi([0 1],[Nbits, 1]);




