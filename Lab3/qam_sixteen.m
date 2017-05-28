%16QAM

clear all
close all

M = 16;
nbit = log2(M);


Ns = 8;
Nbits = 1e6;
N = Ns*Nbits/nbit;


R = randi([0 1],[Nbits 1]);


%Mapping used in the slides - Gray

S = [ -3+3*j -1+3*j 1+3*j 3+3j  -3+j -1+j   1+j   3+j -3-j -1-j   1-j   3-j -3-3*j -1-3*j 1-3*j -3-3*j].';

ak = zeros(length(R)/nbit,1);

jj = 1;

for ii = 1:nbit:(length(R)+1-nbit)
    if (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0 && R(ii+3) == 0)
        ak(jj) = S(1);
        
    elseif (R(ii) == 0 && R(ii+1) == 1 && R(ii+2) == 0 && R(ii+3) == 0)
        ak(jj) = S(2);
        
    elseif (R(ii) == 1 && R(ii+1) == 1 && R(ii+2) == 0 && R(ii+3) == 0)
        ak(jj) = S(3);
        
    elseif (R(ii) == 1 && R(ii+1) == 0 && R(ii+2) == 0 && R(ii+3) == 0)
        ak(jj) = S(4);
        
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0 && R(ii+3) == 1)
        ak(jj) = S(5);
        
    elseif (R(ii) == 0 && R(ii+1) == 1 && R(ii+2) == 0 && R(ii+3) == 1)
        ak(jj) = S(6);
        
    elseif (R(ii) == 1 && R(ii+1) == 1 && R(ii+2) == 0 && R(ii+3) == 1)
        ak(jj) = S(7);
        
    elseif (R(ii) == 1 && R(ii+1) == 0 && R(ii+2) == 0 && R(ii+3) == 1)
        ak(jj) = S(8);
        
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 1 && R(ii+3) == 1)
        ak(jj) = S(9);
        
    elseif (R(ii) == 0 && R(ii+1) == 1 && R(ii+2) == 1 && R(ii+3) == 1)
        ak(jj) = S(10);
        
    elseif (R(ii) == 1 && R(ii+1) == 1 && R(ii+2) == 1 && R(ii+3) == 1)
        ak(jj) = S(11);
        
    elseif (R(ii) == 1 && R(ii+1) == 0 && R(ii+2) == 1 && R(ii+3) == 1)
        ak(jj) = S(12);
    
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 1 && R(ii+3) == 0)
        ak(jj) = S(13);
    
    elseif (R(ii) == 0 && R(ii+1) == 1 && R(ii+2) == 1 && R(ii+3) == 0)
        ak(jj) = S(14);
    
    elseif (R(ii) == 1 && R(ii+1) == 1 && R(ii+2) == 1 && R(ii+3) == 0)
        ak(jj) = S(15);
    
    elseif (R(ii) == 1 && R(ii+1) == 0 && R(ii+2) == 1 && R(ii+3) == 0)
        ak(jj) = S(16);
    
    end
    jj = jj+1;
    
end

%Signal transmitted

x = rectpulse(ak,Ns);

Ps = mean(abs(x.^2));  %Perché diverso dal calcolo?


for ii = 1:length(ak)
    Es(ii) = (abs(ak(ii).^2));
end
Es = Es';
%AWGN

EbNo = linspace(1,8,8);

sigma = (Ps*Ns/2)*10.^(-EbNo./10); 

stdev = sigma.^(1/2);

noise1 = stdev.*randn(N,1);
noise2 = stdev.*randn(N,1);


%Receiver

yrx = zeros(length(ak),1);  %Signal received

val = zeros(length(ak),1);
pos = zeros(length(ak),1);

SER = zeros(length(EbNo),1);
D = zeros(length(ak),M); %Vector of distances

for ii = 1:8
    
    y = (real(x)+noise1(:,ii)/2) + j*(imag(x)+noise2(:,ii)/2);
    
    kk = 1;
    
    for jj = 1:Ns:(length(y)-Ns)
        
        yrx(kk) = 1./sqrt(Es(kk)).*sum(y(jj:(jj+Ns))); 
        kk = kk+1;
    end
    
     for jj = 1:length(S)
         D(:,jj) = distance(yrx,S(jj));
         [val,pos] = min(D,[],2); 
 
     end
  
     sout = S(pos');
   
     errors = sout-ak;
     
     tot = sum(errors ~= 0)
   
     SER(ii) = tot/length(ak);
end

EbNolin = 10.^(EbNo./10);
SERth = (1-1/sqrt(M))*erfc(((3*nbit)/(2*M-2)).^0.5 .* EbNolin.^0.5);
semilogy(EbNo,SERth,'r-');
hold on
semilogy(EbNo,SER,'b*');

