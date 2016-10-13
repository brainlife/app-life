function [fh, fe, out] = life(config)
% 
% This function perfroms a bare minimum processing using the version of
% LiFE distributed under the encode toolbox
%
% Franco Pestilli, Indiana University, frakkopesto@gmail.com.
%
fe = feConnectomeInit(config.diff.dwi, ...
                      config.trac.ptck, ...
                      'temp',[], ...
                      [], ...
                      config.anatomy.t1, ...
                      config.life_discretization,[1,0]);

disp('iterations')
disp(config.num_iterations)

Fit = feFitModel(feGet(fe,'model'), ...
                 feGet(fe,'dsigdemeaned'), ...
                 'bbnnls', ...
                 config.num_iterations, ...
                 'preconditioner');

fe = feSet(fe,'fit',Fit);
                  
out.life.w    = feGet(fe,'fiber weights');
out.life.rmse = feGet(fe,'vox rmse');

% Plot connectome error
[y, x]              = hist(out.life.rmse,40);
out.plot(1).title   = 'Connectome error';
out.plot(1).x.vals  = x;
out.plot(1).x.label = 'r.m.s.e. (image intensity)';
out.plot(1).x.scale = 'log';

out.plot(1).y.vals  = y;
out.plot(1).y.label = 'Number of voxels';
out.plot(1).y.scale = 'linear';

[fh(1)]             = plotHistRMSE(out);
clear x y

% Plot connectome weights
[y, x]              = hist(out.life.w( out.life.w > 0 ),logspace(-5,-.3,40));
out.plot(2).title   = 'Connectome fascicels weights';
out.plot(2).x.vals  = x;
out.plot(2).x.label = 'r.m.s.e. (image intensity)';
out.plot(2).x.scale = 'log';

out.plot(2).y.vals  = y;
out.plot(2).y.label = 'Number of fascicles';
out.plot(2).y.scale = 'linear';
[fh(2)]             = plotHistWeights(out);

end

% ---------- Local Plot Functions ----------- %
function [fh, rmse] = plotHistRMSE(info)
% 
% Make a plot of the error of LiFE (RMSE)
%
figName = sprintf('Connectome error (RMS in predicting the data)');
fh      = mrvNewGraphWin(figName);
plot(info.plot(1).x.vals,info.plot(1).y.vals,'k-');
set(gca,'tickdir','out','fontsize',16,'box','off', ...
    'xscale',info.plot(1).x.scale, ...
    'yscale',info.plot(1).y.scale);
title( info.plot(1).title,'fontsize',12);
ylabel(info.plot(1).y.label,'fontsize',12);
xlabel(info.plot(1).x.label,'fontsize',12);

end

function [fh, w] = plotHistWeights(info)
%
% Make a plot of the weights of LiFE (fascicles weights):
%
figName = sprintf('Connectome fascicle weights');
fh      = mrvNewGraphWin(figName);

plot(info.plot(2).x.vals,info.plot(2).y.vals,'k-','linewidth',2)
set(gca,'tickdir','out','fontsize',16,'box','off', ...
        'yscale', info.plot(2).y.scale, ...
        'xscale',info.plot(2).x.scale);
title( info.plot(2).title,   'fontsize',16)
ylabel(info.plot(2).y.label,'fontsize',16)
xlabel(info.plot(2).x.label,'fontsize',16)
end
