function [] = main()

if ~isdeployed
    % used to run natively (through matlab)
    disp('loading paths')

    addpath(genpath('/N/u/brlife/git/encode'))
    %addpath(genpath('/N/u/hayashis/git/encode'))

    addpath(genpath('/N/u/brlife/git/vistasoft'))
    addpath(genpath('/N/u/brlife/git/jsonlab'))

    addpath(genpath('/usr/local/encode'))
    addpath(genpath('/usr/local/vistasoft'))
    addpath(genpath('/usr/local/jsonlab'))
end

% load my own config.json
config = loadjson('config.json')

if isfield(config,'dtiinit')
    disp('using dtiinit aligned dwi')
    dt6 = loadjson(fullfile(config.dtiinit, 'dt6.json'))
    dwi = fullfile(config.dtiinit, dt6.files.alignedDwRaw)
end

if isfield(config,'dwi')
    disp('using dwi')
    dwi = config.dwi
end

[ fe, out ] = life(config, dwi);

out.stats.input_tracks = length(fe.fg.fibers);
out.stats.non0_tracks = length(find(fe.life.fit.weights > 0));
fprintf('number of original tracks	: %d\n', out.stats.input_tracks);
fprintf('number of non-0 weight tracks	: %d (%f)\n', out.stats.non0_tracks, out.stats.non0_tracks / out.stats.input_tracks*100);

disp('checking output')
if ~isequal(size(fe.life.fit.weights), size(fe.fg.fibers))
    disp('output weights and fibers does not match.. terminating')
    disp(['fe.life.fit.weights', num2str(size(fe.life.fit.weights))])
    disp(['fe.fg.fibers', num2str(size(fe.fg.fibers))])
    exit;
end

disp('writing output_fe.mat')
save('output_fe.mat','fe', '-v7.3');

disp('creating subsampledtracts.json for visualization');
fg = feGet(fe,'fibers acpc');
w = feGet(fe,'fiber weights');
fg = fgExtract(fg, w > 0, 'keep');
w = w(w>0)';
fibers = fg.fibers(1:3:end);
fibers = cellfun(@(x) round(x,2), fibers, 'UniformOutput', false);
connectome.name = 'subsampled(30%). non-0 weighted life output';
connectome.coords = fibers';
connectome.weights = w(1:3:end);
mkdir('tracts')
savejson('', connectome, fullfile('tracts', 'subsampledtracts.json'));

%for old stats graph (lifestats)
out.life = [];
savejson('out', out, 'life_results.json');

disp('creating product.json')
mat1 = out.plot(1);
mat2 = out.plot(2);

plot1 = struct;
plot1.data = struct;
plot1.layout = struct;
plot1.type = 'plotly';
plot1.name = mat1.title;

plot1.data.x = mat1.x.vals;
plot1.data.y = mat1.y.vals;
plot1.data = {plot1.data};

%plot1.layout.title = mat1.title;

plot1.layout.xaxis = struct;
plot1.layout.xaxis.title = mat1.x.label;
plot1.layout.xaxis.type = mat1.x.scale;

plot1.layout.yaxis = struct;
plot1.layout.yaxis.title = mat1.y.label;
plot1.layout.yaxis.type = mat1.y.scale;

plot2 = struct;
plot2.data = struct;
plot2.layout = struct;
plot2.type = 'plotly';
plot2.name = mat2.title;

plot2.data.x = mat2.x.vals;
plot2.data.y = mat2.y.vals;
plot2.data = {plot2.data};

plot2.layout.xaxis = struct;
plot2.layout.xaxis.title = mat2.x.label;
plot2.layout.xaxis.type = mat2.x.scale;

plot2.layout.yaxis = struct;
plot2.layout.yaxis.title = mat2.y.label;
plot2.layout.yaxis.type = mat2.y.scale;

plot3 = struct;
plotdata = loadjson('plotdata.json');
plot3.data = plotdata.data;
plot3.layout = plotdata.layout;
plot3.type = 'plotly';
plot3.name = 'Connectome Evaluation';
marker = struct;
marker.mode = 'markers';
marker.name = 'Your Data';
rmse = nanmean(feGet(fe,'voxrmses0norm'));
density = feGet(fe,'connectome density');
marker.x = { rmse };
marker.y = { density };
marker.marker = struct;
marker.marker.sizemode = 'area';
marker.marker.size = 20;
marker.marker.opacity = 0.9;
marker.marker.color = '#008cba';
plot3.data{end+1} = marker;

textual_output = struct;
textual_output.type = 'info';
textual_output.msg = strcat('Fibers with non-0 evidence: ', ...
    num2str(out.stats.non0_tracks), ' out of ', ...
    num2str(out.stats.input_tracks), ' total tracks (', ...
    num2str(out.stats.non0_tracks/out.stats.input_tracks*100), '% -- it should be between 20%-30%)');
%textual_output.msg = textual_output.msg{1};

product_json = struct;
product_json.brainlife = {plot3, plot2, plot1, textual_output};

%also store some important info 
product_json.life = out.stats;
product_json.life.rmse = rmse;
product_json.life.density = density;

savejson('', product_json, 'product.json');

disp('all done')

end
