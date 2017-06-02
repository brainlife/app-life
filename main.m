
function [] = main()

%if exist('/N/u/hayashis/BigRed2/git', 'dir') == 7
%if exist('/home/hayashis/git', 'dir') == 7
switch getenv('ENV')
case 'IUHPC'
    disp('loading paths (HPC)')
    addpath(genpath('/N/u/hayashis/BigRed2/git/encode-mexed'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
case 'VM'
    disp('loading paths (VM)')
    addpath(genpath('/home/hayashis/git/encode-mexed'))
    addpath(genpath('/home/hayashis/git/vistasoft'))
    addpath(genpath('/home/hayashis/git/jsonlab'))
end

% load my own config.json
config = loadjson('config.json')

[ fe, out ] = life(config);

disp('writing outputs')
save('output_fe.mat','fe', '-v7.3');

%I am not sure if we really need to do save this?
fgWrite(out.life.fg, 'output_fg.pdb');

%savejson('w',    out.life.w,    'life_fascicle_weights.json');
%savejson('rmse', out.life.rmse, 'life_error.json');

out.life = [];
savejson('out',  out,      'life_results.json');

disp('all done')

end
