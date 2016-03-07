function [ X ] = Generate_G( Nx, realizations )

Set_Default_Plot_Properties();

sigma = 2;
ell = 0.2;
a = 1/2;
b = 10;

x = linspace(-a,a,Nx);
[lh, phih] = Analytical_Eigs(sigma, ell, a, b, x);

X = ones(realizations,Nx); % Initialize to one because <G(x)> = 1.0;
hwait = waitbar(0,'Generating realizations of G...');
for r = 1:realizations
    if mod(r,10) == 0
        waitbar(r / realizations, hwait)
    end
    Y = randn(1,b);
    for i = 1:b
        X(r,:) = X(r,:) + sqrt(lh(i)) * phih(:,i)' * Y(i);
    end
end
close(hwait)

end