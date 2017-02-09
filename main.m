
function [] = main()

if isempty(getenv('SCA_SERVICE_DIR'))
    setenv('SCA_SERVICE_DIR', pwd)
end

if exist('/N/u/hayashis/BigRed2/git', 'dir') == 7
    disp('loading karst paths')
    addpath(genpath('/N/u/hayashis/BigRed2/git/encode-mexed'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
end

% load my own config.json
config = loadjson('config.json');

[ fh, fe, out ] = life(config);

fgWrite(out.life.fg, 'output_fg.pdb');
save('output_fe.mat','fe', '-v7.3');
savejson('w',    out.life.w,    'life_fascicle_weights.json');
savejson('rmse', out.life.rmse, 'life_error.json');
out.life = [];
savejson('out',  out,      'life_results.json');

for ii = 1:length(fh)
    saveas(fh(ii), sprintf('figure%i.png',ii))
end

end
