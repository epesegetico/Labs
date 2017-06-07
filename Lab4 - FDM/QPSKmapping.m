function [symbolsOut] = QPSKmapping(bitSequence,symbols,nbit)

symbolsOut = zeros(1,length(bitSequence)/nbit);

jj = 1;

for ii = 1:nbit:(length(bitSequence)+1-nbit)  %OK
    if (bitSequence(ii) == 0 && bitSequence(ii+1) == 0);
        symbolsOut(jj) = symbols(1);
       
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 0);
        symbolsOut(jj) = symbols(2);
       
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 1);
        symbolsOut(jj) = symbols(3);
        
    else 
        symbolsOut(jj) = symbols(4);
        
    end
    jj = jj+1;
end


