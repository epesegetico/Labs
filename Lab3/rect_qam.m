clear all
close all

% Rectangular 8-QAM - MANCA DEMODULATORE E BER

M = 8;
nbit = log2(M);


Ns = 4;
Nbits = 3e6;
N = Ns*Nbits/nbit;

bitsIn = randi([0 1],[Nbits 1]);


%Mapping - Gray coding
jj = 1;

S = [-3+j -1+j 1+j 3+j -3-j -1-j  1-j 3-j];

ak = zeros(length(bitsIn)/nbit,1);


for ii=1:nbit:(length(bitsIn)+1-nbit)
    if (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0);
        ak(jj) = S(1);
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1);
        ak(jj) = S(2);
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1);
        ak(jj) = S(3);
    elseif (bitsIn(ii) == 0 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 0);
        ak(jj) = S(4);
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 0);
        ak(jj) = S(5);
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 1 && bitsIn(ii+2) == 1);
        ak(jj) = S(6);
    elseif (bitsIn(ii) == 1 && bitsIn(ii+1) == 0 && bitsIn(ii+2) == 1);
        ak(jj) = S(7);
    else 
        ak(jj) = S(8);
    end
       
    jj = jj+1;
    end
  
   
x = rectpulse(ak,Ns);

Ps = mean(abs(x).^2);

%AWGN

EbNo = linspace(2,12,8);
EbNolin = 10.^(EbNo./10);

sigma = (Ps*Ns)./(nbit*EbNolin);

stdev =  1/sqrt(2) * sigma.^(1/2);




%Receiver

yrx = zeros(length(ak),1);  %Signal received

val = zeros(length(ak),1);
pos = zeros(length(ak),1);

SER = zeros(length(EbNo),1);
BER = SER;

bitsOut = zeros(length(bitsIn),1);
D = zeros(length(ak),M); %Vector of distances

for ii = 1:length(EbNo)
    noise1 = stdev(ii)*randn(N,1);
    
    noise2 =stdev(ii)*randn(N,1);
    

    y = (real(x)+noise1) + j*(imag(x)+noise2);
    
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
     
     tot = sum(abs(errors ~= 0))
   
     SER(ii) = tot/(length(ak));
     ind2 = 1;
     
     for ind1 = 1:length(symbolsOut)
        if symbolsOut(ind1) == S(1)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            
        elseif symbolsOut(ind1) == S(2)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(3)
            
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(4)
           
            bitsOut(ind2) = 0;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            
        elseif symbolsOut(ind1) == S(5)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 0;
            
        elseif symbolsOut(ind1) == S(6)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 1;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(7)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 1;
            
        elseif symbolsOut(ind1) == S(8)
            
            bitsOut(ind2) = 1;
            bitsOut(ind2+1) = 0;
            bitsOut(ind2+2) = 0;
            
        end
        
        
        
        ind2 = ind2+nbit;
            
             
            
     end
    
 
     
    bitErrors = sum(abs(bitsOut-bitsIn) ~= 0)
    
    BER(ii) = bitErrors/length(bitsIn);
     
end

EbNolin = 10.^(EbNo./10);


SERth = 5/4 * erfc((0.5*EbNolin).^0.5) - 3/8 *erfc((0.5*EbNolin).^0.5).^2;
BERth = 5/12 * erfc((0.5*EbNolin).^0.5) ;

%Plot della SER

semilogy(EbNo,SERth,'r-');
hold on
grid on
semilogy(EbNo,SER,'b*');
title('Rectangular 8-QAM Modulation - Symbol Error Rate');
xlabel('Eb/No [dB]');
ylabel('Symbol Error Rate');
legend('Rectangular 8-QAM','Rectangular 8-QAM Simulation');


%Plot del BER
figure

semilogy(EbNo,BERth,'r-');
hold on
grid on
semilogy(EbNo,BER,'b*');
title('Rectangular 8-QAM Modulation - Bit Error Rate');
xlabel('Eb/No [dB]');
ylabel('Bit Error Rate');
legend('Rectangular 8-QAM','Rectangular 8-QAM Simulation');

%Plot della costellazione

figure

cloudplot(real(yrx),imag(yrx),[],'true');