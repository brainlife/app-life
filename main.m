
function [] = main()

switch getenv('ENV')
case 'IUHPC'
    disp('loading paths (HPC)')
    addpath(genpath('/N/u/brlife/git/encode'))
    addpath(genpath('/N/u/brlife/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))
case 'VM'
    disp('loading paths (VM)')
    addpath(genpath('/usr/local/encode-mexed'))
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
end

% load my own config.json
config = loadjson('config.json')
dtiinit_config = loadjson(fullfile(config.dtiinit,'product.json'))

% construct aligned dwi path
aligned_dwi = fullfile(config.dtiinit, dtiinit_config.dt6.files.alignedDwRaw)

[ fe, out ] = life(config, aligned_dwi);

out.stats.input_tracks = length(fe.fg.fibers);
out.stats.non0_tracks = length(find(fe.life.fit.weights > 0));
fprintf('number of original tracks	: %d\n', out.stats.input_tracks);
fprintf('number of non-0 weight tracks	: %d (%f)\n', out.stats.non0_tracks, out.stats.non0_tracks / out.stats.input_tracks*100);

disp('writing outputs')
save('output_fe.mat','fe', '-v7.3');

%used to visualize result on web
out.life = [];
savejson('out',  out,      'life_results.json');

%% for visualizing the tracks in viewer
% Extract the fascicles
fg = feGet(fe,'fibers acpc');

% Extract the fascicle weights from the fe structure
% Dependency "encode".
w = feGet(fe,'fiber weights');

% Eliminate the fascicles with non-zero entries
% Dependency "vistasoft"
fg = fgExtract(fg, w > 0, 'keep');

fg_sub = fg;
cell2mat(fg.fibers');
fg_sub.fibers = fg.fibers(1:10:end,:);
fg_sub.fibers = cellfun(@(x) round(x,4), fg_sub.fibers, 'UniformOutput', false);

connectome.name = 'subsampled (x10) pos. weighted life output';
connectome.coords = fg_sub.fibers;
connectome.weights = w(1:10:end,:);

mkdir('tracts')
savejson('', connectome, fullfile('tracts', 'subsampledtracts.json'));

system('echo 0 > finished');
disp('all done')

end
