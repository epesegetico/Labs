%NRZ passband digital transmission system with different modulations
%Better create a modular program

%QPSK
%nbits form a symbol 
%for labelling try gray coding
%ak must be complex in order to use the IQ components of the signal 
%Consider the complex envelope of the signal

%AWGN
%formed by 2 independent uncorrelated WGN for I and Q

%RECEIVER
%General case: as seen in Digital Transmission class (signal spaces makes the work easier)
%Integral becomes a sum -> always a complex number, decision generally on
%the Voronoi regions but it's easier by using distance from the signals

clc
clear all
close all

M = 4;
nbit = log2(M);

Ns = 4;
Nbits = 1e6;
N = Ns*Nbits/nbit;

%Transmitter

R = randi([0 1],[Nbits 1]);

ak = zeros(length(R)/2,1);

jj = 1;

%Mapping

S = [1+j -1+j -1-j 1-j];

for ii = 1:2:length(R)
    if (R(ii) == 0 && R(ii+1) == 0);
        ak(jj) = S(1);
       
    elseif (R(ii) == 1 && R(ii+1) == 0);
        ak(jj) = S(2);
       
    elseif (R(ii) == 1 && R(ii+1) == 1);
        ak(jj) = S(3);
        
    else  (R(ii) == 0 && R(ii+1) == 1);
        ak(jj) = S(4);
        
    end
    jj = jj+1;
end

x = rectpulse(ak,Ns);
Ps = mean(abs(x.^2));

%AWGN

EbNo = linspace(1,8,8);

sigma = (Ps*Ns/2)*10.^(-EbNo./10);

stdev = sigma.^(1/2);

noise1 = stdev.*randn(N,1);
noise2 = stdev.*randn(N,1);

yrx = zeros(length(ak),1);
val = yrx;
pos = val;
D = zeros(length(ak),4);

for ii = 1:8
    y = (real(x)+noise1(:,ii)) + j*(imag(x)+noise2(:,ii));
    kk = 1;
    for jj = 1:Ns:(length(y)-Ns)
        
        yrx(kk) = sum(y(jj:(jj+Ns)));
        kk = kk+1;
    end
    
     for jj = 1:length(S)
         D(:,jj) = distance(yrx,S(jj));
         [val,pos] = min(D,[],2); 
         
     end
  
     sout = S(pos').';
   
     errors = sout-ak;
     
     sum(errors ~= 0)
end


               
