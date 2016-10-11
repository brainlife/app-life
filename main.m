
function [] = main()

if isempty(getenv('SCA_SERVICE_DIR'))
    disp('setting SCA_SERVICE_DIR to pwd')
    setenv('SCA_SERVICE_DIR', pwd)
end

disp('loading paths')
addpath(genpath('/N/u/hayashis/BigRed2/git/encode'))
addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
%addpath(genpath('/N/u/hayashis/BigRed2/git/mba')) %not used by life?
addpath(genpath(getenv('SCA_SERVICE_DIR'))) %load life scripts and all

%load my own config.json
config = loadjson('config.json');

[ fh, fe ] = life(config.diff.dwi, [], config.anatomy.t1, config.trac.ptck, config.trac.dtck)

saveas(pfe, 'prb_fit_fe.mat')
saveas(dfe, 'dtr_fit_fe.mat')

saveas(fh(0), 'figure0.png') %1-base index?
saveas(fh(1), 'figure1.png')
saveas(fh(2), 'figure2.png')
saveas(fh(3), 'figure3.png')
saveas(fh(4), 'figure4.png')
saveas(fh(5), 'figure5.png')
saveas(fh(6), 'figure6.png')

end
