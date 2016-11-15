
function [] = main()

if isempty(getenv('SCA_SERVICE_DIR'))
    disp('setting SCA_SERVICE_DIR to pwd')
    setenv('SCA_SERVICE_DIR', pwd)
end

disp('loading paths')
addpath(genpath('/N/u/hayashis/BigRed2/git/encode'))
addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))

%addpath(genpath('/N/u/hayashis/BigRed2/git/mba')) %not used by life?
%addpath(genpath(getenv('SCA_SERVICE_DIR'))) %load life scripts and all

% load my own config.json
config = loadjson('config.json');

% update symlink to realpath
%display(config.diff.dwi)gymnastics
%[status,config.diff.dwi] = system(sprintf('readlink -f %s', config.diff.dwi));
%display(config.diff.dwi)

[ fh, fe, out ] = life(config);

save('output_fe.mat','fe', '-v7.3');
savejson('w',    out.life.w,    'life_fascicle_weights.json');
savejson('rmse', out.life.rmse, 'life_error.json');
out.life = [];
savejson('out',  out,      'life_results.json');

for ii = 1:length(fh)
    saveas(fh(ii), sprintf('figure%i.png',ii))
end

end
