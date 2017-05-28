%MANCANO PEZZI RIGUARDANTI:
% * SER E BER Teorici,
% * BER effettivo (differenza tra bit ricevuti e bit trasmessi)
% * Chiedere per quanto riguarda il rumore separato tra i due canali





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

clear all
close all

M = 4;
nbit = log2(M);

Ns = 4;
Nbits = 1e6;
N = Ns*Nbits/nbit;

%Transmitter

R = randi([0 1],[Nbits 1]);

ak = zeros(length(R)/nbit,1);

jj = 1;

%Mapping

S = [1+j -1+j -1-j 1-j];

for ii = 1:nbit:(length(R)+1-nbit)  %OK
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

for ii = 1:length(ak)
    Es(ii) = sum(abs(ak(ii).^2));
end
%AWGN


EbNo = linspace(2,12,8);
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns/2)*10.^(-EbNo./10);

stdev = sigma.^(1/2);

noise1 = stdev.*randn(N,1);
noise2 = stdev.*randn(N,1);

yrx = zeros(length(ak),1);
val = yrx;
pos = val;
D = zeros(length(ak),4);
SER = zeros(length(EbNo),1);

for ii = 1:length(EbNo)
    
    y = (real(x)+noise1(:,ii)/2) + j*(imag(x)+noise2(:,ii)/2);
   
    kk = 1;
    
    for jj = 1:Ns:(length(y)-Ns)
        
        yrx(kk) = sum(y(jj:(jj+Ns)));  %CONTROLLARE GLI INDICI
        kk = kk+1;
    end
    
     for jj = 1:length(S)
         D(:,jj) = distance(yrx,S(jj));
         [val,pos] = min(D,[],2); 
         
     end
  
     sout = S(pos).';
   
     errors = sout-ak;
     
     tot = sum(errors ~= 0);
     
     SER(ii) = tot/(length(ak));
end

SERth = (M-1)/2.*erfc((EbNolin).^0.5);

semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'bo');
               
