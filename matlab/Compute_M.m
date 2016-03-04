function [ M ] = Compute_M( x )
%%%
% IN:
%      x - discretized domain
% OUT:
%      M - [M_ij] = \int_D \phi_i(x1) \phi_j(x1) dx1
%%%

% Constants.
dx   = x(2) - x(1); % spacing between x-values (assumes uniform)
nsh1 = length(x);   % # 1d shape functions

% Allocate M matrix.
M = zeros(nsh1);

% Fill M matrix.
for i = 1:nsh1
    M(i,i) = 2*dx/3;
end
M(1,1)       = dx/3;
M(nsh1,nsh1) = dx/3;

for i = 1:(nsh1-1)
    M(i,i+1) = dx/6;
    M(i+1,i) = dx/6;
end

end