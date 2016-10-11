function [fh, fe, out] = life(config)
% 
% This function perfroms a bare minimum processing using the version of
% LiFE distributed under the encode toolbox
%
% Franco Pestilli, Indiana University, frakkopesto@gmail.com.
%
L = 360; 
fe = feConnectomeInit(config.diff.dwi, ...
                      config.trac.ptck, ...
                      'temp',[], ...
                      config.diff.dwi, ...
                      config.anatomy.t1,L,[1,0]);

Niter = 500;
fe = feSet(fe,'fit',feFitModel(feGet(fe,'model'),feGet(fe,'dsigdemeaned'),'bbnnls',Niter,'preconditioner'));
                  
out.w    = feGet(fe,'fiber weights');
out.rmse = feGetRep(fe,'vox rmse');

[fh(1), ~, ~] = plotHistRMSE(out);
[fh(2), ~] = plotHistWeights(out);

end

% ---------- Local Plot Functions ----------- %
function [fh, rmse, rmsexv] = plotHistRMSE(info)
% 
% Make a plot of the error of LiFE (RMSE)
%
rmse   = info.rmse;

figName = sprintf('%s - RMSE',info.tractography);
fh = mrvNewGraphWin(figName);
[y,x] = hist(rmse,50);
plot(x,y,'k-');
set(gca,'tickdir','out','fontsize',16,'box','off');
title('Root-mean squared error distribution across voxels','fontsize',16);
ylabel('number of voxels','fontsize',16);
xlabel('rmse (scanner units)','fontsize',16);
end

function [fh, w] = plotHistWeights(info)
%
% Make a plot of the weights of LiFE (fascicles weights):
%
w       = info.w;
figName = sprintf('%s - Distribution of fascicle weights',info.tractography);
fh      = mrvNewGraphWin(figName);
[y,x]   = hist(w( w > 0 ),logspace(-5,-.3,40));
semilogx(x,y,'k-','linewidth',2)
set(gca,'tickdir','out','fontsize',16,'box','off')
title( ...
    sprintf('Number of fascicles candidate connectome: %2.0f\nNumber of fascicles in optimized connetome: %2.0f' ...
    ,length(w),sum(w > 0)),'fontsize',16)
ylabel('Number of fascicles','fontsize',16)
xlabel('Fascicle weight','fontsize',16)
end
