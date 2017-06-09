
function [] = main()

switch getenv('ENV')
case 'IUHPC'
    disp('loading paths (HPC)')
    addpath(genpath('/N/u/hayashis/BigRed2/git/encode-mexed'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
case 'VM'
    disp('loading paths (VM)')
    addpath(genpath('/usr/local/encode-mexed'))
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
end

% load my own config.json
config = loadjson('config.json')

[ fe, out ] = life(config);

disp('writing outputs')
save('output_fe.mat','fe', '-v7.3');

out.life = [];

%used to visualize result on web
savejson('out',  out,      'life_results.json');

disp('all done')

end
