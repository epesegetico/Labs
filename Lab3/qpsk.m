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
% %Integral becomes a sum -> always a complex number, decision generally on
%the Voronoi regions but it's easier by using distance from the signals

clear all
close all

M = 4;
nbit = log2(M);

Ns = 8;
Nbits = 1e6;
N = Ns*Nbits/nbit;

%Transmitter

R = randi([0 1],[Nbits 1]);

ak = zeros(length(R)/nbit,1);

jj = 1;

%Mapping

S = [1+1i -1+1i -1-1i 1-1i];

for ii = 1:nbit:(length(R)+1-nbit)  %OK
    if (R(ii) == 0 && R(ii+1) == 0);
        ak(jj) = S(1);
       
    elseif (R(ii) == 1 && R(ii+1) == 0);
        ak(jj) = S(2);
       
    elseif (R(ii) == 1 && R(ii+1) == 1);
        ak(jj) = S(3);
        
    else 
        ak(jj) = S(4);
        
    end
    jj = jj+1;
end  

x = rectpulse(ak,Ns);
Ps = mean(abs(S).^2); 


%AWGN


EbNo = linspace(1,8,8);
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns*nbit)./(2*EbNolin); 

stdev = sigma.^(1/2);



yrx = zeros(length(ak),1);
val = yrx;
pos = val;

D = zeros(length(ak),M);
SER = zeros(length(EbNo),1);

for ii = 1:length(EbNo)
    noise1 = stdev(ii)*randn(N,1);

    noise2 = stdev(ii)*randn(N,1);
    y = (real(x)+noise1/2) + 1i*(imag(x)+noise2/2); %RISULTA COINCIDENTE CON LA TEORIA se il rumore è la metà per ogni modulazione
   
    %y = x;
    
    kk = 0;
    
    for jj = 0:Ns:(length(y)-4)
        
        kk = kk+1;
        
        yrx(kk) = 1/Ns * sum(y(jj+1:(jj+Ns)));  %CONTROLLARE GLI INDICI - MANCA 1/sqrt(es)
       
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

SERth = erfc((EbNolin).^0.5) - 1/4 * (erfc(EbNolin.^0.5).^2);  %SER teorico per qpsk (4-psk)

BERth = SERth/nbit;

semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'b*');
title('QPSK Modulation');
xlabel('Eb/No [dB]');
ylabel('Symbol Error Rate');
legend('QPSK','QPSK Simulated');

%MANCA IL BER