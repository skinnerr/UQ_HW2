function [ l, phix ] = Galerkin_Eigs( sigma, ell, b, x )
%%%
% IN:
%      sigma - standard deviation of correlation function
%      ell   - correlation length parameter
%      b     - # of eigenpairs to compute
%      x     - points to calculate eigenfunctions
% OUT:
%      l     - eigenvalues
%      phix  - eigenfunctions evaluated over x
%%%

% Define covariance function.
Cxx = @(x1,x2) sigma^2 * exp(-abs(x1 - x2) / ell);

%%%%%%%%%%%%%%%%%%%%
% Compute matrices %
%%%%%%%%%%%%%%%%%%%%

C = Compute_C(Cxx, x);

M = Compute_M(x);

%%%%%%%%%%%%%%%%%%%%%%%
% Compute eigensystem %
%%%%%%%%%%%%%%%%%%%%%%%

[phix, l] = eigs(C,M,b);

[l, order] = sort(diag(l),'descend');
phix = phix(:,order);

end