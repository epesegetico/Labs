%Star QAM

clear all
close all

% Rectangular 8-QAM - MANCA DEMODULATORE E BER

M = 8;
nbit = log2(M);


Ns = 8;
Nbits = 3e6;
N = Ns*Nbits;

bitsIn = randi([0 1],[Nbits 1]);


%Mapping - Gray coding
jj = 1;

S = [-1-sqrt(3) -1+j j*(1+sqrt(3)) 1+j 1+sqrt(3) 1-j -j*(1+sqrt(3)) -1-j];

ak = zeros(length(bitsIn)/nbit,1);


for ii=1:nbit:(length(bitsIn)+1-nbit)
    if (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 0)
        ak(jj) = S(1);
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0)
        ak(jj) = S(2);
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1)
        ak(jj) = S(3);
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1)
        ak(jj) = S(4);
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1)
        ak(jj) = S(5);
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1)
        ak(jj) = S(6);
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0)
        ak(jj) = S(7);
    else 
        ak(jj) = S(8);
    end
       
    jj = jj+1;
    end
  
   
x = rectpulse(ak,Ns);

Ps = mean(abs(x).^2);

%AWGN

EbNo = [2:2:12];
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns)./(nbit*EbNolin);

stdev =  1/sqrt(2) * sigma.^(1/2);






%Receiver

yrx = zeros(length(ak),1);  %Signal received

val = zeros(length(ak),1);
pos = zeros(length(ak),1);

SER = zeros(length(EbNo),1);

D = zeros(length(ak),M); %Vector of distances
bitsOut = zeros(length(bitsIn),1);

for ii = 1:length(EbNo)
    
    noise1 = stdev(ii)*randn(length(x),1);
    noise2 = stdev(ii)*randn(length(x),1);

    
    
    y = (real(x)+noise1(:)) + j*(imag(x)+noise2(:));
    

    
    kk = 1;
    
    for jj = 0:Ns:(length(y)-Ns)
        yrx(kk) = 1/Ns * sum(y(jj+1:(jj+Ns))); 
        kk = kk+1;
    end
    
     for jj = 1:length(S)
         D(:,jj) = distance(yrx,S(jj));
         [~,pos] = min(D,[],2); 
     end
  
     symbolsOut = S(pos).';
   
     errors = symbolsOut-ak;
     
     tot = sum(abs(errors ~= 0));
   
     SER(ii) = tot/(length(ak));
ind2 = 1;
    
    for ind1 = 1:length(symbolsOut)
        if symbolsOut(ind1) == S(1)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            
        elseif symbolsOut(ind1) == S(2)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            
        elseif symbolsOut(ind1) == S(3)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(4)
           
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(5)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(6)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(7)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            
        elseif symbolsOut(ind1) == S(8)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            
        end
        
        
        
        ind2 = ind2+nbit;
            
             
            
        end
    
    bitErrors = sum(abs(bitsOut-bitsIn) ~= 0);
    
    BER(ii) = bitErrors/length(bitsIn);
end



upperSER = 3.5 * erfc(((3-sqrt(3))/2 * EbNolin).^0.5);
lowerSER = 1/8 * erfc(((3-sqrt(3))/2 * EbNolin).^0.5);

semilogy(EbNo,upperSER,'r-');
hold on
grid on
semilogy(EbNo,lowerSER,'r-');
semilogy(EbNo,SER,'b*');
legend('Upper Bound','Lower Bound','Simulation');


%Plot del BER

semilogy(EbNo,SER,'g-');
hold on
grid on
semilogy(EbNo,SER/log2(M),'g-');
semilogy(EbNo,BER,'bo');
title('Star 8-QAM Modulation');
xlabel('Eb/No [dB]');
ylabel('Bit Error Rate');
legend('SER Upper Bound','SER Lower Bound','SER Simulated','BER Upper Bound','BER Lower Bound','BER Simulated');
cleanfigure();
matlab2tikz('star_BER.tex');
%Plot della costellazione

figure

cloudplot(real(yrx),imag(yrx),[],'true');

cleanfigure();
matlab2tikz('star_cloud.tex');