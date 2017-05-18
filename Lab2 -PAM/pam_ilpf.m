%2-PAM with ILPF

Ns = 4;
Nbits = 1e6;  

Rin = randi([0 1],[Nbits, 1]);

ak = zeros(Nbits,1);

%Mapping dei valori

for ii = 1:length(Rin)
    if Rin(ii) == 0
        ak(ii) = -1;
    else
        ak(ii) = 1;
    end
    
end

x = rectpulse(ak,Ns);

