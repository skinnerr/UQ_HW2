function [ F ] = Gauss2D( f, x1, x2, dx )
%%%
% IN:
%      f  - function to integrate
%      x1 - start of interval on x1
%      x2 - start of interval on x2
%      dx - uniform spacing between points on x-axes, assuming same on each axis
% OUT:
%      F  - numerical integral result
%%%

% Pre-allocate variables.
gw = [1/2, 1/2];                         % Gauss quad weights
gx = ([-1/sqrt(3), 1/sqrt(3)] + 1) / 2;  % Gauss quad locations on [0,1].

% Perform Gaussian quadrature.
F = 0;
for i = 1:2
    for j = 1:2
        xi = x1 + dx * gx(i);
        xj = x2 + dx * gx(j);
        tmp = gw(i) * gw(j) * f(xi, xj);
        F = F + tmp;
    end
end
F = F * dx^2;

end