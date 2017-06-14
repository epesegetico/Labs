%MANCANO PEZZI RIGUARDANTI:
% * SER E BER Teorici,
% * BER effettivo (differenza tra bit ricevuti e bit trasmessi)
% * Chiedere per quanto riguarda il rumore separato tra i due canali





%NRZ passband digital transmission system with different modulations
%Better create a modular program

%QPSK
%nbits form a symbol 
%for labelling try gray coding
%symbolsIn must be complex in order to use the IQ components of the signal 
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

bitsIn = randi([0 1],[Nbits 1]);

symbolsIn = zeros(length(bitsIn)/nbit,1);

jj = 1;

%Mapping

S = [1+1i -1+1i -1-1i 1-1i];


for ii = 1:nbit:(length(bitsIn)+1-nbit)  %OK
    if (bitsIn(ii) == 0 && bitsIn(ii+1) == 0);
        symbolsIn(jj) = S(1);
       
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0);
        symbolsIn(jj) = S(2);
       
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1);
        symbolsIn(jj) = S(3);
        
    else 
        symbolsIn(jj) = S(4);
        
    end
    jj = jj+1;
end  

x = rectpulse(symbolsIn,Ns);
Ps = mean(abs(x).^2); 


%AWGN


EbNo = [2:2:12];
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns)./(nbit*EbNolin); 

stdev = 1/sqrt(2) * sigma.^(1/2);



yrx = zeros(length(symbolsIn),1);


D = zeros(length(symbolsIn),M);

SER = zeros(length(EbNo),1);
BER = SER;

bitsOut = zeros(length(bitsIn),1);



for ii = 1:length(EbNo)
    noise1 = stdev(ii)*randn(N,1);

    noise2 = stdev(ii)*randn(N,1);
    y = (real(x)+noise1) + 1i*(imag(x)+noise2); %RISULTA COINCIDENTE CON LA TEORIA se il rumore è la metà per ogni modulazione
   
    %y = x;
    
    kk = 0;
    
    for jj = 0:Ns:(length(y)-Ns)
        
        kk = kk+1;
        
        yrx(kk) = 1/Ns * sum(y(jj+1:(jj+Ns)));  %CONTROLLARE GLI INDICI - MANCA 1/sqrt(es)
       
    end
    
    for ind = 1:length(S)
         D(:,ind) = distance(yrx,S(ind));
         [~,pos] = min(D,[],2); 
         
     end
  
     symbolsOut = S(pos).';
   
     symbolErrors = symbolsOut-symbolsIn;
     
     tot = sum(abs(symbolErrors) ~= 0);
     
     
     SER(ii) = tot/(length(symbolsIn));   %SER per ogni EbNo è dato dal rapporto tra il totale degli errori e il numero di simboli inviati
     
     
     ind2 = 1;
     for ind1 = 1:length(symbolsOut)
         if symbolsOut(ind1) == S(1)
             
             bitsOut(ind2) = 0;
             bitsOut(ind2+1) = 0;
             
         elseif symbolsOut(ind1) == S(2)
             
             bitsOut(ind2) = 1;
             bitsOut(ind2+1) = 0;
             
         elseif symbolsOut(ind1) == S(3)
             
              bitsOut(ind2) = 1;
              bitsOut(ind2+1) = 1;
              
         else
             
              bitsOut(ind2) = 0;
              bitsOut(ind2+1) = 1;
              
         end
         
         ind2 = ind2+nbit;
         
     end
     
     
     bitErrors = sum(abs(bitsOut-bitsIn) ~= 0)
     
     BER(ii) = bitErrors/length(bitsIn);
     
end

SERth = erfc((EbNolin).^0.5) - 1/4 * (erfc(EbNolin.^0.5).^2);  %SER teorico per qpsk (4-psk)

BERth = SERth/nbit;

%semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'r-');
title('QPSK Modulation');
xlabel('Eb/No [dB]');

BERth = SERth./nbit;

% semilogy(EbNo,BERth,'g-');
% hold on
% grid on
% semilogy(EbNo,BER,'bo');
title('QPSK Modulation');
xlabel('Eb/No [dB]');
ylabel('Bit Error Rate');
legend('SER','SER Simulated','BER','BER Simulated');
figure

cloudplot(real(yrx),imag(yrx),[],'true');
title('QPSK scatter plot');