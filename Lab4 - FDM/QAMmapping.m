function [symbolsOut] = QAMmapping(bitSequence,symbols,nbit)

symbolsOut = zeros(1,length(bitSequence)/nbit);

jj = 1;

for ii = 1:nbit:(length(bitSequence)+1-nbit)
    if (bitSequence(ii) == 0 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(1);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(2);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(3);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(4);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(5);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(6);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(7);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 0 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(8);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(9);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(10);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(11);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 1)
        symbolsOut(jj) = symbols(12);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(13);
        
    elseif (bitSequence(ii) == 0 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(14);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 1 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(15);
        
    elseif (bitSequence(ii) == 1 && bitSequence(ii+1) == 0 && bitSequence(ii+2) == 1 && bitSequence(ii+3) == 0)
        symbolsOut(jj) = symbols(16);
        
    end
    
    jj = jj+1;
    
end


