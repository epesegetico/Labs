%16QAM - FUNZIONA SE Ps è la potenza della costellazione
close all
clear all


M = 16;
nbit = log2(M);


Ns = 4;
Nbits = 1e6;
N = Ns*Nbits/nbit;


R = randi([0 1],[Nbits 1]);


%Mapping used in the slides - Gray

S = [ -3+3*j -1+3*j 1+3*j 3+3j  -3+j -1+j   1+j   3+j -3-j -1-j   1-j   3-j -3-3*j -1-3*j 1-3*j 3-3*j];

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

Ps = mean(abs(x).^2);  %potrebbe essere il problema

%AWGN
EbNo = linspace(2,12,8);
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns*nbit)./(2*EbNolin); 

stdev =  1/2 * sigma.^(1/2);



%Receiver

yrx = zeros(length(ak),1);  %Signal received

SER = zeros(length(EbNo),1);

D = zeros(length(ak),M); %Vector of distances

for ii = 1:length(EbNo)
    noise1 = 1/2 *stdev(ii)*randn(N,1);
    
    noise2 = 1/2 *stdev(ii)*randn(N,1);
    
    y = (real(x)+noise1) + j*(imag(x)+noise2);
   
    %y = x;
    
    kk = 0;
    
    for jj = 0:Ns:(length(y)-Ns) 
        
        kk = kk+1;
        
        yrx(kk) = 1/Ns * sum(y((jj+1):(jj+Ns)));  
       
    end
    
    for ind = 1:length(S)
         D(:,ind) = distance(yrx,S(ind));
         [~,pos] = min(D,[],2); 
         
     end
  
     sout = S(pos).';
   
     symbolErrors = sout-ak;
     
     tot = sum(abs(symbolErrors) ~= 0);
     
     
     SER(ii) = tot/(length(ak));   %SER per ogni EbNo è dato dal rapporto tra il totale degli errori e il numero di simboli inviati
end



p = (1-1/sqrt(M))*erfc(((3*nbit.*EbNolin)./(2*M-2)).^0.5); 

SERth = 2.*p - p.^2;

SERQPSK = erfc((EbNolin).^0.5) - 1/4 * (erfc(EbNolin.^0.5).^2);


semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'b*');
semilogy(EbNo,SERQPSK,'--');
xlabel('Eb/No [dB]');
ylabel('Symbol Error Rate');
legend('16-QAM','16-QAM simulated','QPSK');


