% Rectangular 8-QAM

M = 8;
nbit = log2(M);


Ns = 4;
Nbits = 1e5;
N = Nbits*Ns;

R = randi([0 1],[Nbits 1]);


%Mapping - Gray coding



S = [-3+j -1+j 1+j 3+j -3-j -1-j  1-j 3-j];

ak = zeros(length(R)/nbit,1);


for ii=1:nbit:length(R)
    if (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    elseif (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)
    else (R(ii) == 0 && R(ii+1) == 0 && R(ii+2) == 0)

       
    end
end
