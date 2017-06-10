%16QAM - FUNZIONA SE Ps è la potenza della costellazione
close all
clear all


M = 16;
nbit = log2(M);


Ns = 8;
Nbits = 1e6;
N = Ns*Nbits/nbit;


bitsIn = randi([0 1],[Nbits 1]);


%Mapping used in the slides - Gray

S = [ -3+3*j -1+3*j 1+3*j 3+3j  -3+j -1+j   1+j   3+j -3-j -1-j   1-j   3-j -3-3*j -1-3*j 1-3*j 3-3*j];

symbolsIn = zeros(length(bitsIn)/nbit,1);
jj = 1;

for ii = 1:nbit:(length(bitsIn)+1-nbit)
    if (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(1);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(2);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(3);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(4);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(5);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(6);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(7);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 0 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(8);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(9);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(10);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(11);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 1)
        symbolsIn(jj) = S(12);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(13);
        
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(14);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(15);
        
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1 && bitsIn(ii+3) == 0)
        symbolsIn(jj) = S(16);
        
    end
    
    jj = jj+1;
    
end

%Signal transmitted

x = rectpulse(symbolsIn,Ns);

Ps = mean(abs(x).^2);  %potrebbe essere il problema

%AWGN
EbNo = [2:2:12]
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns)./(nbit*EbNolin);

stdev =  1/sqrt(2) * sigma.^(1/2);



%Receiver

yrx = zeros(length(symbolsIn),1);  %Signal received

SER = zeros(length(EbNo),1);
BER = SER;

bitsOut = zeros(length(bitsIn),1);


D = zeros(length(symbolsIn),M); %Vector of distances

for ii = 1:length(EbNo)
    noise1 = stdev(ii)*randn(N,1);
    
    noise2 = stdev(ii)*randn(N,1);
    
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
    
    symbolsOut = S(pos).';
    
    symbolErrors = symbolsOut-symbolsIn;
    
    tot = sum(abs(symbolErrors) ~= 0);
    
    
    SER(ii) = tot/(length(symbolsIn));   %SER per ogni EbNo è dato dal rapporto tra il totale degli errori e il numero di simboli inviati
    
    ind2 = 1;
    
    for ind1 = 1:length(symbolsOut)
        if symbolsOut(ind1) == S(1)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 0;
            
        elseif symbolsOut(ind1) == S(2)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 0;
        elseif symbolsOut(ind1) == S(3)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 0;
            
        elseif symbolsOut(ind1) == S(4)
           
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 0;
            
        elseif symbolsOut(ind1) == S(5)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(6)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(7)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(8)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(9)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(10)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(11)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(12)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 1;
            
        elseif symbolsOut(ind1) == S(13)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 0;
            
        elseif symbolsOut(ind1) == S(14)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 0;
        elseif symbolsOut(ind1) == S(15)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 0;
        else
            
             bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            bitsOut(ind2+3) = 0;
        end
        
        
        
        ind2 = ind2+nbit;
            
             
            
        end
    
    
    bitErrors = sum(abs(bitsOut-bitsIn) ~= 0);
    
    BER(ii) = bitErrors/length(bitsIn);
    
end



p = (1-1/sqrt(M))*erfc(((3*nbit.*EbNolin)./(2*M-2)).^0.5);

SERth = 2.*p - p.^2;



semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'b*');

xlabel('Eb/No [dB]');

BERth = 3/8 * erfc((2/5*EbNolin).^0.5);

semilogy(EbNo,BERth,'g-');
hold on
grid on
semilogy(EbNo,BER,'bo');
title('16-QAM Modulation');
xlabel('Eb/No [dB]');

legend('SER','SER Simulated','BER ','BER Simulated');

cleanfigure();
matlab2tikz('qam16_BER.tex');


%Plot della costellazione

figure

cloudplot(real(yrx),imag(yrx),[],'true');
cleanfigure();
matlab2tikz('qam16_cloud.tex');



