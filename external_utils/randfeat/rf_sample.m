function obj = rf_sample(obj)
% rf_sample samples from the distribution 
%
% copyright (c) 2010 
% Fuxin Li - fuxin.li@ins.uni-bonn.de
% Catalin Ionescu - catalin.ionescu@ins.uni-bonn.de
% Cristian Sminchisescu - cristian.sminchisescu@ins.uni-bonn.de

switch obj.distribution
  case {'gaussian','rbf'}
    S = sqrt(obj.kernel_param) * sqrt(2) * randn(obj.dim, obj.Napp);
  case 'sech'
    % for chi2 kernel
    % here we use the inverse method for sampling
    snet = rand(obj.dim, obj.Napp);
    S = 2/pi*log(tan(pi/2 * snet));
  case 'cauchy'
    % for intersection kernel
    S = obj.kernel_param * tan(pi * (rand(obj.dim, obj.Napp) - 0.5));
  case 'period'
    S = floor((2:(obj.Nperdim+1))/2);
    % Change Napp to the correct form
    obj.Napp = obj.dim * (length(S) + 1);
    obj.Nperdim = length(S)+1;
    S = obj.period * repmat(S, [obj.dim 1]);
  case 'uniform'
    % Change Napp to the correct form
    S = obj.period * [0: 1/(obj.Nperdim-1) :1];% rand(1, obj.Nperdim)
  case 'chebyshev'
    S = [];
  case 'exp_chi2'
    switch obj.method
      case 'signals'
        S = floor((2:(obj.Nperdim+1))/2);
        obj.Nperdim = length(S)+1;
        S = obj.period * repmat(S, [obj.dim 1]);
%        S = obj.period *[-S S];
        % Change Napp to the correct form
                
      case 'sampling'
        error('Not implemented!');
      case 'chebyshev'
        % No sampling
        S = [];
%        obj.Nperdim = obj.Nperdim * 2 + 2;
    end
    % Always have omega2 for the second step Gaussian
    obj.dim * obj.Nperdim
    obj.Napp
    obj.omega2 = sqrt(obj.kernel_param) * sqrt(2) * randn(obj.dim*obj.Nperdim+1,obj.Napp);
  otherwise
    error('Unknown sampling distribution');
end
obj.omega = S;
end
