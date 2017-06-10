% FDM Simulation

close all
clear all

Nbit = 1e6;
Ns = 24;
f0 = 1.5 ;

%QPSK

nbit = 2;

S = [1+1i -1+1i -1-1i 1-1i];
Nsymb = Nbit/nbit;


%Frequenza
df = 1/Nsymb;
f = [-Ns/2:df:Ns/2-df];
N = length(f);


%Sequenze di bit casuali per i 3 canali
bits_tx = randi([0 1],[1,Nbit]);
bits_tx_l = randi([0 1],[1,Nbit]);
bits_tx_r = randi([0 1],[1,Nbit]);

%Mapping 2 bits per simbolo, gray code
symbolsIn = QPSKmapping(bits_tx,S,nbit);
symbols_l = QPSKmapping(bits_tx_l,S,nbit);
symbols_r = QPSKmapping(bits_tx_r,S,nbit);

%Creazione dei tre segnali e sfasamento

xtx_cut = rectpulse(symbolsIn,Ns);
xtx_l = rectpulse(symbols_l,Ns);
xtx_r = rectpulse(symbols_r,Ns);

t = [0:1:length(xtx_cut)-1]*(1/Ns);


xtx_l = xtx_l .* exp(-1i*2*pi*f0*t);
xtx_r = xtx_r .* exp(1i*2*pi*f0*t);

%somma dei segnali prima della trasmissione e relativa PSD

xtx = xtx_cut+xtx_l+xtx_r;

Bartlett(xtx,1000,Ns);

cleanfigure();
matlab2tikz('fdm_qpsk_PSD.tex');

Ps = mean(abs(xtx_cut).^2);

%AWGN


EbNo_dB = [2:2:12];
EbNo = 10.^(EbNo_dB./10);

sigma = (Ps*Ns)./(nbit*EbNo); 

stdev = 1/sqrt(2) * sigma.^(1/2);

yrx = zeros(length(symbolsIn),1);

pos = yrx;

D = zeros(length(symbolsIn),2^nbit);

SER = zeros(length(EbNo),1);
BER = SER;

bitsOut = zeros(1,length(bits_tx));



for ii = 1:length(EbNo_dB)
    
    noise1 = stdev(ii) * randn(1,length(xtx));
    noise2 = stdev(ii) * randn(1,length(xtx));
    
    xrx = (real(xtx)+noise1) + 1i * (imag(xtx)+noise2);
    %xrx = xtx;
       

    kk = 0;
    
    for jj = 0:Ns:(length(xrx)-Ns)
        
        kk = kk+1;
        
        yrx(kk) = 1/Ns * sum(xrx(jj+1:(jj+Ns))); 
        
    end
    
    
    for ind = 1:length(S)
         D(:,ind) = distance(yrx,S(ind));
         [~,pos] = min(D,[],2); 
         
     end
  
     symbolsOut = S(pos);
   
     symbolErrors = symbolsOut-symbolsIn;
     
     tot = sum(abs(symbolErrors) ~= 0)
     
     
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
     
     
     bitErrors = sum(abs(bitsOut-bits_tx) ~= 0)
     
     BER(ii) = bitErrors/length(bits_tx);
     
end

SERth = erfc((EbNo).^0.5) - 1/4 * (erfc(EbNo.^0.5).^2);  %SER teorico per qpsk (4-psk)

BERth = SERth/nbit;

semilogy(EbNo_dB,SERth,'r-');
hold on
grid on
semilogy(EbNo_dB,SER,'r*');



BERth = SERth./nbit;

semilogy(EbNo_dB,BERth,'b-');
hold on
grid on
semilogy(EbNo_dB,BER,'bo');
title('FDM QPSK Modulation');
xlabel('Eb/No [dB]');

legend('SER','SER Simulated','BER','BER Simulated');

% cleanfigure();
% matlab2tikz('fdm_qpsk_BER.tex');
figure

cloudplot(real(yrx),imag(yrx),[],'true');
title('FDM - QPSK scatter plot');
% 
% 
% cleanfigure();
% matlab2tikz('fdm_qpsk_cloud.tex');