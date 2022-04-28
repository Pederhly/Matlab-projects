clear;
clc;

%loader sys
load hV2.mat
y = data.Data;
load u.mat
u = data.Data;

Ts = 50/length(u); %samplingstid
z = iddata(y,u,Ts);

na = 1:2; %grad mellom 1 til 3
nb = 1:2; %antall pådrags-ledd
nc = 1:2; %antall avviks-ledd
nk = 0:2; %tidsforsinkelse

models = cell(1,12); 
ct = 1;
for i = 1:2
    na_ = na(i);
    nb_ = na(i);
    for j = 1:2
        nc_ = nc(j);
        for k = 1:3
            nk_ = nk(k); 
            models{ct} = armax(z,[na_ nb_ nc_ nk_]);
            ct = ct+1;
        end
    end
end

%velger den modellen som passer best
models = stack(1,models{:});
compare(z,models) 

%hvor X er den modellen som velges
h=d2c(tf(models(:,:,3)));
grid;