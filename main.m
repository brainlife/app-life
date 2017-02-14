
function [] = main()

%if isempty(getenv('SCA_SERVICE_DIR'))
%    setenv('SCA_SERVICE_DIR', pwd)
%end

if exist('/N/u/hayashis/BigRed2/git', 'dir') == 7
    disp('loading karst paths (bigred2)')
    addpath(genpath('/N/u/hayashis/BigRed2/git/encode-mexed'))
    %addpath(genpath('/N/u/hayashis/BigRed2/git/encode'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
end

if exist('/root/git', 'dir') == 7
    disp('loading karst paths (jetstream)')
    addpath(genpath('/root/git/encode-mexed'))
    addpath(genpath('/root/git/vistasoft'))
    addpath(genpath('/root/git/jsonlab'))
end

% load my own config.json
config = loadjson('config.json');

[ fe, out ] = life(config);

disp('writing outputs')
save('output_fe.mat','fe', '-v7.3');
fgWrite(out.life.fg, 'output_fg.pdb');
%savejson('w',    out.life.w,    'life_fascicle_weights.json');
%savejson('rmse', out.life.rmse, 'life_error.json');

out.life = [];
savejson('out',  out,      'life_results.json');

%for ii = 1:length(fh)
%    saveas(fh(ii), sprintf('figure%i.png',ii))
%end

disp('all done')

end
