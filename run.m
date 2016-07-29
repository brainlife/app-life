
addpath(getenv('SCA_SERVICE_DIR'))
addpath(genpath('/N/u/hayashis/Karst/life/vistasoft-master'))
%addpath(genpath('./data'))
addpath(genpath(getenv('SCA_SERVICE_DIR')))

disp(pwd)

% TODO - parse config.json - pull input_task_id
% TODO - parse products.json from ../<inpu_task_id>/products.json
% TODO - for dwi_path parse config.json from the tracking job's dwi_path

path

%[ fh, pfe, dfe ] = life_demo(dwiFile, t1File, ptckFileNme, dtckFileName)
[ fh, pfe, dfe ] = life_demo(dwiFile, t1File, ptckFileNme, dtckFileName)

saveas(pfe, 'prb_fit_fe.mat')
saveas(dfe, 'dtr_fit_fe.mat')
saveas(fh(0), 'figure0.png')
saveas(fh(1), 'figure1.png')
saveas(fh(2), 'figure2.png')
saveas(fh(3), 'figure3.png')
saveas(fh(4), 'figure4.png')
saveas(fh(5), 'figure5.png')
