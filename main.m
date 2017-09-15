
function [] = main()

switch getenv('ENV')
case 'IUHPC'
    disp('loading paths (HPC) - mexpro')
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
fg_sub.fibers = round(fg.fibers(1:10:end,:), 4);

connectome.name = 'subsampled (x10) pos. weighted life output';
connectome.coords = fg_sub.fibers;
connectome.weights = w(1:10:end,:);
connectome.color = [0.2052473684,0.2466526316,0.6930631579]; 

mkdir('tracts')
savejson('', connectome, fullfile('tracts', 'subsampledtracts.json'));


system('echo 0 > finished');
disp('all done')

end
