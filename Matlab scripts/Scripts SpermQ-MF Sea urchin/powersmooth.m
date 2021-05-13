function vecs=powersmooth(vec,order,weight,Mode)
% vecs=powersmooth(vec,order,weight)
% smoothes time series vec by quadratic programming with Bayesian prior on order-th derivative
%{
This function was copied from https://www.mathworks.com/matlabcentral/fileexchange/48799-powersmooth

LICENSE NOTES:
Copyright (c) 2015, Benjamin Friedrich
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}

% column vector
if nargin == 3
    Mode ='Fast';
end

vec=vec(:);
% cost function to be minimized
% cost = @(vec,vecs) sum( (vec-vecs).^2 ) + ...
%                     weight*sum( diff(vecs,order).^2 );

% rewriting cost function as quadratic form: vecs.A.vecs+vecs.b+c->min
n=length(vec);
switch Mode 
    case 'Fast'
        A0=speye(n); % part corresponding to distance function
        switch order
            case 1
                A1=spdiags([1 2*ones(1,n-2) 1])-2*spdiags([ones(1,n-1)],1); % part corresponding to first derivative
            case 2
                A1=spdiags([1 5 6*ones(1,n-4) 5 1])-4*spdiags([1 2*ones(1,n-3) 1],1)+2*spdiags(ones(1,n-2),2); % part corresponding to second derivative, obsolete
            case 3
                A1=spdiags([1 10 19 20*ones(1,n-6) 19 10 1])-6*spdiags([1 4 5*ones(1,n-5) 4 1],1)+6*spdiags([1 2*ones(1,n-4) 1],2)-2*spdiags(ones(1,n-3),3); % part corresponding to third derivative
            otherwise
                fprintf('Order=%d not supported.\n',order)
        end
    otherwise
        A0=eye(n); % part corresponding to distance function
        switch order
            case 1
                A1=diag([1 2*ones(1,n-2) 1])-2*diag([ones(1,n-1)],1); % part corresponding to first derivative
            case 2
                A1=diag([1 5 6*ones(1,n-4) 5 1])-4*diag([1 2*ones(1,n-3) 1],1)+2*diag(ones(1,n-2),2); % part corresponding to second derivative, obsolete
            case 3
                A1=diag([1 10 19 20*ones(1,n-6) 19 10 1])-6*diag([1 4 5*ones(1,n-5) 4 1],1)+6*diag([1 2*ones(1,n-4) 1],2)-2*diag(ones(1,n-3),3); % part corresponding to third derivative
            otherwise
                fprintf('Order=%d not supported.\n',order)
        end
end
A=A0+weight*A1;
A=0.5*(A+A'); % symmetrize A
b=-2*vec; % linear term unchanged

% solve linear system to find minimum
vecs=-2*A\b;
return
end
