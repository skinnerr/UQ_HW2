function [ C ] = Compute_C( Cxx, x )
%%%
% IN:
%      Cxx - covariance function of (x1, x2)
%      x   - discretized domain
% OUT:
%      C   - [C_ij] = \int_D Cxx(x1,x2) \phi_i(x1) \phi_j(x2) dx1 dx2
%%%

% Constants.
dx   = x(2) - x(1); % spacing between x-values (assumes uniform)
nsh1 = length(x);   % # 1d shape functions
nen  = 4;           % # element nodes
nel  = (nsh1-1)^2;  % # global elements

% Pre-allocate C matrix.
C = zeros(nsh1);

% Generate various mapping arrays.
[IEN, AN1D, EX] = Generate_Maps(nsh1);

% Loop over elements and local nodes, assembling element-wise contributions to C.
for e = 1:nel
    
    x1_start = x(EX(e,1));
    x2_start = x(EX(e,2));
    
    for a = 1:nen
        
        % Global node number and basis function index.
        A = IEN(e,a);
        I = AN1D(A,1);
        J = AN1D(A,2);

        % Function to integrate; piecewise linear shape functions explicitly included.
        % Note: shape functions assume all x > 0.
        fun = @(x1,x2) Cxx(x1,x2) * (1 - abs(I - 1 - x1/dx)) ...
                                  * (1 - abs(J - 1 - x2/dx));
        
        % Perform quadrature.
        tmp = Gauss2D(fun, x1_start, x2_start, dx);
        
        % Augment C.
        C(I,J) = C(I,J) + tmp;
        
    end
end

end