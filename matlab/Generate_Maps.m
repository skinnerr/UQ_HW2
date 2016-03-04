function [ IEN, AN1D, EX ] = Generate_Maps( nsh1 )
%%%
% IN:
%      nsh1 - length of the x vector, assumes 2D space indexed by identical vectors
% OUT:
%      IEN  - array mapping element e and local node a to global node A: IEN(e,a) = A
%      AN1D - array mapping global node A to 1D node index along axis 1 or 2; note
%                 numbering of global nodes proceeds in the x1 direction, wrapping up to
%                 the next x2-index to continue
%      EX   - array mapping element e to smallest 1D local node indices it exists on
%                 over axis 1 or 2
%%%

% Constants.
nen = 4;        % # local nodes
nsh2 = nsh1^2;    % # global nodes
nel = (nsh1-1)^2; % # global elements

% Initialize arrays, assume quadrilateral elements.
IEN  = nan(nel, nen);
AN1D = nan(nsh2, 2);
EX   = nan(nel, 2);

%%%%%%%%%%%%%%%%
% Fill in IEN. %
%%%%%%%%%%%%%%%%

e = 1:nel;

for a = 1:2
    IEN(:,a) = e + (a-1) + floor( (e-1) / (nsh1-1) );
end

for a = 3:4
    IEN(:,a) = e + floor( (e-1) / (nsh1-1) ) + (nsh1+1) - (a-(nen-1));
end

%%%%%%%%%%%%%%%%%
% Fill in AN1D. %
%%%%%%%%%%%%%%%%%

A = 1:nsh2;

AN1D(:,1) = 1 + mod(A-1,nsh1);
AN1D(:,2) = 1 + floor((A-1)/nsh1);

%%%%%%%%%%%%%%%%%
% Fill in EX. %
%%%%%%%%%%%%%%%%%

e = 1:nel;

EX(:,1) = 1 + mod(e-1,nsh1-1);
EX(:,2) = 1 + floor((e-1)/(nsh1-1));

end

