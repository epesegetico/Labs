function Bartlett(y,Repetition,Bsim)
%BARTLETT Summary of this function goes here
%   Detailed explanation goes here

N = length(y);
Frame = N/Repetition;

df_Bartlett=Repetition*(Bsim/N);
f_Bartlett=[-Bsim/2: df_Bartlett : Bsim/2-df_Bartlett ];


F_Bartlett=zeros(1,Frame);
for Counter=1:Repetition
    F=1/Frame^2/df_Bartlett*abs(fftshift(fft(y((Counter-1)*Frame+1:(Counter-1)*Frame+Frame)))).^2;
    F_Bartlett=F_Bartlett+F;
end
F_Bartlett=F_Bartlett/Repetition;

figure

plot(f_Bartlett,10*log10(F_Bartlett),'r-','Linewidth',1)


end

