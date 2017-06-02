%Star QAM

clear all
close all

% Rectangular 8-QAM

M = 8;
nbit = log2(M);


Ns = 4;
Nbits = 9e6;
N = Ns*Nbits;

R = randi([0 1],[Nbits 1]);


%Mapping - Gray coding
jj = 1;

S = [-1-sqrt(3) -1+j j*(1+sqrt(3)) 1+j 1+sqrt(3) 1-j -j*(1+sqrt(3)) -1-j];

ak = zeros(length(R)/nbit,1);


for ii=1:nbit:(length(R)+1-nbit)
    if (R(ii) == 1 && R(ii+1) == 0 && R(ii+2) == 0);
        ak(jj) = S(1);
    elseif (R(ii) == 1 && R(ii+1) == 1 && R(ii+2) == 0);
        ak(jj) = S(2);
    elseif (R(ii) == 1 && R(ii+1) == 1 && R(ii+2) == 1);
        ak(jj) = S(3);
    elseif (R(ii) == 1 && R(ii+1) == 0 && R(ii+2) == 1);
        ak(jj) = S(4);
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 1);
        ak(jj) = S(5);
    elseif (R(ii) == 0 && R(ii+1) == 1 && R(ii+2) == 1);
        ak(jj) = S(6);
    elseif (R(ii) == 0 && R(ii+1) == 1 && R(ii+2) == 0);
        ak(jj) = S(7);
    else 
        ak(jj) = S(8);
    end
       
    jj = jj+1;
    end
  
   
x = rectpulse(ak,Ns);

Ps = mean(abs(S).^2);

%AWGN

EbNo = linspace(2,12,8);

sigma = (Ps*Ns/2)*10.^(-EbNo./10); 

stdev = 1/2 * sigma.^(1/2);



%Receiver

yrx = zeros(length(ak),1);  %Signal received

val = zeros(length(ak),1);
pos = zeros(length(ak),1);

SER = zeros(length(EbNo),1);

D = zeros(length(ak),M); %Vector of distances

for ii = 1:length(EbNo)
    
    noise1 = stdev(ii)*randn(length(x),1);
    noise2 = stdev(ii)*randn(length(x),1);

    
    
    y = (real(x)+noise1(:)) + j*(imag(x)+noise2(:));
    
    %y = x;
    
    kk = 1;
    
    for jj = 0:Ns:(length(y)-Ns)
        yrx(kk) = 1/Ns * sum(y(jj+1:(jj+Ns))); 
        kk = kk+1;
    end
    
     for jj = 1:length(S)
         D(:,jj) = distance(yrx,S(jj));
         [~,pos] = min(D,[],2); 
     end
  
     sout = S(pos).';
   
     errors = sout-ak;
     
     tot = sum(abs(errors ~= 0))
   
     SER(ii) = tot/(length(ak));
end

EbNolin = 10.^(EbNo./10);


p = (1-1/sqrt(M))*erfc(((3*nbit.*EbNolin)./(2*M-2)).^0.5); 

SERth = 2.*p - p.^2;

semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'b*');