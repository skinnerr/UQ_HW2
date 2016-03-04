function [ X ] = Generate_G( Nx, realizations )

Set_Default_Plot_Properties();

sigma = 2;
ell = 0.2;
a = 1/2;
b = 10;

x = linspace(0,2*a,Nx);
[lh, phih] = Galerkin_Eigs(sigma, ell, b, x);

X = ones(realizations,Nx); % Initialize to one because <G(x)> = 1.0;
for r = 1:realizations
    Y = randn(1,b);
    for i = 1:b
        X(r,:) = X(r,:) + sqrt(lh(i)) * phih(:,i)' * Y(i);
    end
end

end