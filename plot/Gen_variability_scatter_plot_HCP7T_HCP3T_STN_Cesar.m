function Gen_variability_scatter_plot_HCP7T_HCP3T_STN_Cesar

addpath(genpath('/N/u/brlife/git/jsonlab'))

DataPath = '/N/dc2/projects/lifebid/code/ccaiafa/Caiafa_Pestilli_paper2015/Revision_Feb2017/Results/Variability/';

HCP_subject_set = {'111312','105115','113619','110411'};
STN_subject_set = {'KK_96dirs_b2000_1p5iso','FP_96dirs_b2000_1p5iso','HT_96dirs_b2000_1p5iso','MP_96dirs_b2000_1p5iso'};
%HCP7T_subject_set = {'108323','131217','109123','910241'};
%HCP7T_subject_set = {'108323','109123','910241','102311'};
%HCP7T_subject_set = {'108323','109123','111312_7T','125525','102311_Paolo_masks'};
HCP7T_subject_set = {'108323','109123','111312_7T','125525','102311'};
% 131217 has a bad wm_mask!!!

fh = figure('name','combined scatter mean ±sem across repeats','color','w');
set(fh,'Position',[0,0,800,600]);

Nalg = 13; %(6 Prob + 6 Stream + Tensor)

% plot HCP
Gen_plot(HCP_subject_set,'cold',DataPath,Nalg,'HCP3T90')

% plot STN
Gen_plot(STN_subject_set,'medium',DataPath,Nalg,'STN96')

Nalg = 9; %(4 Prob + 4 Stream + Tensor)

% plot HCP7T
Gen_plot(HCP7T_subject_set,'hot',DataPath,Nalg,'HCP7T60')

% % plot HCP3T60
% Gen_plot(HCP_subject_set,'hot',DataPath,Nalg,'HCP3T60')

set(gca,'tickdir','out', 'ticklen',[0.025 0.025], ...
         'box','off','ytick',[2 15 32].*10^4, 'xtick', [0.04 0.07 0.1], ...
         'ylim',[2 32].*10^4, 'xlim', [0.04 0.1],'fontsize',20)
axis square
ylabel('Fascicles number','fontsize',20)
xlabel('Connectome error (r.m.s.)','fontsize',20)


%% Single subject scatter showing dependence on lmax parameter
fh = figure('name','Single subject scatter plot', 'color','w');
set(fh,'Position',[800,0,250,200]);

Gen_plot_indiv(HCP_subject_set{4},DataPath,13);

set(gca,'tickdir','out', 'ticklen',[0.025 0.025], ...
         'box','off','ytick',[4  18].*10^4, 'xtick', [0.045 0.065], ...
         'ylim',[4 18].*10^4, 'xlim', [0.045 0.065],'fontsize',12)
axis square
% ylabel('Fascicles number','fontsize',14)
% xlabel('Connectome error (r.m.s.)','fontsize',14)
% title('Single subject (HCP90)','fontsize',12)

%% Nnz vs lmx probabilistic
% fh = figure('name','combined scatter mean ±sem across repeats','color','w');
% set(fh,'Position',[0,0,800,300]);
% 
% % plot HCP
% Nalg = 4; %(4 Prob )
% Gen_plot_vs_lmax_60dir(HCP_subject_set,'medium',DataPath,Nalg,'HCP3T90')
% 
% Gen_plot_vs_lmax_60dir(HCP7T_subject_set,'hot',DataPath,Nalg,'HCP7T60')
% 
% set(gca,'tickdir','out', 'ticklen',[0.025 0.025], ...
%          'box','off','ytick',[2 9 16].*10^4, 'xtick', [2 4 6 8], ...
%          'ylim',[2 16].*10^4, 'xlim', [1 9],'fontsize',20)
%      
% ylabel('Fascicles number','fontsize',20)
% xlabel('L_{max}','fontsize',20)



end

function [] = Gen_plot(subject_set,color_type,DataPath,Nalg,dataset)
nnz_all = zeros(length(subject_set),Nalg,10);
nnz_mean = zeros(length(subject_set),Nalg);
nnz_std  = zeros(length(subject_set),Nalg);

alg_names = cell(1,Nalg);

if Nalg==13
    range_prob = 2:2:12;
    range_det = 3:2:13;
    prob_ix_low = [2:7];
    prob_ix_high = [15:20];
    det_ix_low = [8:13];
    det_ix_high = [21:26];
    ten_ix_low = [1];
    ten_ix_high = [14];
    lmax_order = [3,4,5,6,1,2];
else
    range_prob = 2:2:8;
    range_det = 3:2:9;
    prob_ix_low = [2:5];
    prob_ix_high = [11:14];
    det_ix_low = [6:9];
    det_ix_high = [15:18];
    ten_ix_low = [1];
    ten_ix_high = [10];
    lmax_order = [1,2,3,4];
end

n = 1;
for subject = subject_set;
    
    switch dataset
        case {'HCP7T60','STN96','HCP3T90'}
            DataFile = deblank(ls(char(fullfile(DataPath,strcat('Rmse_nnz_10_connectomes_',subject,'_run01','.mat')))));
        case {'HCP3T60','STN60'}
            DataFile = deblank(ls(char(fullfile(DataPath,strcat('Rmse_nnz_10_connectomes_',subject,'_60dir*run01','.mat'))))); 
    end    
    
    load(DataFile)
    
    m = 1;
    % Tensor
    for p=1:1
        rmse_all(n,m,:) = Result_alg(p).rmse;
        rmse_mean(n,m)  = nanmean(Result_alg(p).rmse);
        rmse_std(n,m)   = nanstd(Result_alg(p).rmse)./sqrt(length(Result_alg(p).rmse));
        
        nnz_all(n,m,:) = Result_alg(p).nnz;
        nnz_mean(n,m)  = nanmean(Result_alg(p).nnz);
        nnz_std(n,m)   = nanstd(Result_alg(p).nnz)./sqrt(length(Result_alg(p).nnz));
        
        alg_names{m} = char(alg_info(p).description);
        m = m +1;
    end

    % Prob
    for p = range_prob  
        rmse_all(n,m,:) = Result_alg(p).rmse;
        rmse_mean(n,m) = nanmean(Result_alg(p).rmse);
        rmse_std(n,m)  = nanstd(Result_alg(p).rmse)./sqrt(length(Result_alg(p).rmse));       
        
        nnz_all(n,m,:) = Result_alg(p).nnz;
        nnz_mean(n,m)  = mean(Result_alg(p).nnz);
        nnz_std(n,m)   = std(Result_alg(p).nnz)./sqrt(length(Result_alg(p).nnz));
        
        alg_names{m} = char(alg_info(p).description);
        m = m +1;
    end

    % Det
    for p = range_det           
        rmse_all(n,m,:) = Result_alg(p).rmse;
        rmse_mean(n,m) = nanmean(Result_alg(p).rmse);
        rmse_std(n,m)  = nanstd(Result_alg(p).rmse)./sqrt(length(Result_alg(p).rmse));
        
        nnz_all(n,m,:) = Result_alg(p).nnz;
        nnz_mean(n,m) = nanmean(Result_alg(p).nnz);
        nnz_std(n,m)  = nanstd(Result_alg(p).nnz)./sqrt(length(Result_alg(p).nnz)); 
        
        alg_names{m} = char(alg_info(p).description);
        m = m +1;
    end

    n = n + 1;
end

c = getNiceColors(color_type);

all = {}
all.subject_set = subject_set;
all.rmse_all = rmse_all;
all.rmse_mean = rmse_mean; 
all.rmse_std = rmse_std;
all.nnz_all = nnz_all;
all.nnz_mean = nnz_mean; 
all.nnz_std = nnz_std;
all.c = c;
all.alg_names = alg_names;

%save(dataset+'.mat', 'all'); 

savejson('', all, [dataset '.json']);

for is  = 1:size(nnz_all,1)    
    tmp_rmse = squeeze(rmse_all(is,:,:));
    tmp_rmse(isinf(tmp_rmse)) = nan;
    
    tmp_nnz = squeeze(nnz_all(is,:,:));
    tmp_nnz(isinf(tmp_nnz)) = nan;
    
    % mu and sem RMSE
    rmse_mu(is,:) = squeeze(nanmean(tmp_rmse,2));
    rmse_ci(is,:) = [rmse_mu(is,:), rmse_mu(is,:)] + 5*([-nanstd(tmp_rmse,[],2),;nanstd(tmp_rmse,[],2)]' ./sqrt(size(tmp_rmse,2)));
    
    % mu and sem NNZ
    nnz_mu(is,:) = squeeze(nanmean(tmp_nnz,2));
    nnz_ci(is,:) = [nnz_mu(is,:), nnz_mu(is,:)] + 5*([-nanstd(tmp_nnz,[],2);nanstd(tmp_nnz,[],2)]' ./sqrt(size(tmp_rmse,2)));
end

%% scatter plot with confidence intervakls first all in gray
a = 0.5;

for ii = 1:length(subject_set) % subjects
   hold on
   % PROB
   for iii = lmax_order
       plot(rmse_mean(ii,prob_ix_low(iii)), nnz_mean(ii,prob_ix_low(iii)),'o','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
       plot([rmse_ci(ii,prob_ix_low(iii)); rmse_ci(ii,prob_ix_high(iii))], [nnz_mu(ii,prob_ix_low(iii)); nnz_mu(ii,prob_ix_low(iii))],'-','color',[a a a],'linewidth',2)
       plot([rmse_mu(ii,prob_ix_low(iii)); rmse_mu(ii,prob_ix_low(iii))], [nnz_ci(ii,[prob_ix_low(iii)]);  nnz_ci(ii,prob_ix_high(iii))],'-','color',[a a a],'linewidth',2)   
   end
   
   % DET
   for iii = lmax_order
       plot(rmse_mean(ii,det_ix_low(iii)), nnz_mean(ii,det_ix_low(iii)),'s','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
       plot([rmse_ci(ii,det_ix_low(iii)); rmse_ci(ii,[det_ix_high(iii)])], [nnz_mu(ii,det_ix_low(iii)); nnz_mu(ii,det_ix_low(iii))],'-','color',[a a a],'linewidth',2)
       plot([rmse_mu(ii,det_ix_low(iii)); rmse_mu(ii,det_ix_low(iii));], [nnz_ci(ii,det_ix_low(iii)); nnz_ci(ii,[det_ix_high(iii)])],'-','color',[a a a],'linewidth',2)
   end
   
   % TENSOR
   plot(rmse_mean(ii,ten_ix_low), nnz_mean(ii,ten_ix_low),'d','markerfacecolor',c(ii,:),'markeredgecolor','k','linewidth',0.5,'markersize',14)
   plot([rmse_ci(ii,ten_ix_low); rmse_ci(ii,ten_ix_high)], [nnz_mu(ii,ten_ix_low); nnz_mu(ii,ten_ix_low)],'-','color',[a a a],'linewidth',2)
   plot([rmse_mu(ii,ten_ix_low); rmse_mu(ii,ten_ix_low)], [nnz_ci(ii,ten_ix_low); nnz_ci(ii,ten_ix_high)],'-','color',[a a a],'linewidth',2)
   
end

end


function [] = Gen_plot_indiv(subject,DataPath,Nalg)
nnz_all = zeros(Nalg,10);
nnz_mean = zeros(Nalg);
nnz_std  = zeros(Nalg);

alg_names = cell(1,Nalg);

if Nalg==13
    range_prob = 2:2:12;
    range_det = 3:2:13;
    prob_ix_low = [2:7];
    prob_ix_high = [15:20];
    det_ix_low = [8:13];
    det_ix_high = [21:26];
    ten_ix_low = [1];
    ten_ix_high = [14];
    lmax_order = [3,4,5,6,1,2];
else
    range_prob = 2:2:8;
    range_det = 3:2:9;
    prob_ix_low = [2:5];
    prob_ix_high = [11:14];
    det_ix_low = [6:9];
    det_ix_hig = [15:18];
    ten_ix_low = [1];
    ten_ix_high = [10];
    lmax_order = [1,2,3,4];
end

DataFile = deblank(ls(char(fullfile(DataPath,strcat('Rmse_nnz_10_connectomes_',subject,'_run01','.mat')))));
load(DataFile)

m = 1;
% Tensor
for p=1:1
    rmse_all(m,:) = Result_alg(p).rmse;
    rmse_mean(m)  = nanmean(Result_alg(p).rmse);
    rmse_std(m)   = nanstd(Result_alg(p).rmse)./sqrt(length(Result_alg(p).rmse));

    nnz_all(m,:) = Result_alg(p).nnz;
    nnz_mean(m)  = nanmean(Result_alg(p).nnz);
    nnz_std(m)   = nanstd(Result_alg(p).nnz)./sqrt(length(Result_alg(p).nnz));

    alg_names{m} = char(alg_info(p).description);
    m = m +1;
end

% Prob
for p = range_prob  
    rmse_all(m,:) = Result_alg(p).rmse;
    rmse_mean(m) = nanmean(Result_alg(p).rmse);
    rmse_std(m)  = nanstd(Result_alg(p).rmse)./sqrt(length(Result_alg(p).rmse));       

    nnz_all(m,:) = Result_alg(p).nnz;
    nnz_mean(m)  = mean(Result_alg(p).nnz);
    nnz_std(m)   = std(Result_alg(p).nnz)./sqrt(length(Result_alg(p).nnz));

    alg_names{m} = char(alg_info(p).description);
    m = m +1;
end

% Det
for p = range_det           
    rmse_all(m,:) = Result_alg(p).rmse;
    rmse_mean(m) = nanmean(Result_alg(p).rmse);
    rmse_std(m)  = nanstd(Result_alg(p).rmse)./sqrt(length(Result_alg(p).rmse));

    nnz_all(m,:) = Result_alg(p).nnz;
    nnz_mean(m) = nanmean(Result_alg(p).nnz);
    nnz_std(m)  = nanstd(Result_alg(p).nnz)./sqrt(length(Result_alg(p).nnz)); 

    alg_names{m} = char(alg_info(p).description);
    m = m +1;
end



c = getNiceColors2();

   
tmp_rmse = rmse_all(:,:);
tmp_rmse(isinf(tmp_rmse)) = nan;

tmp_nnz = nnz_all(:,:);
tmp_nnz(isinf(tmp_nnz)) = nan;

% mu and sem RMSE
rmse_mu = nanmean(tmp_rmse,2);
rmse_ci = [rmse_mu, rmse_mu] + 5*([-nanstd(tmp_rmse,[],2), nanstd(tmp_rmse,[],2)] ./sqrt(size(tmp_rmse,2)));

% mu and sem NNZ
nnz_mu = nanmean(tmp_nnz,2);
nnz_ci = [nnz_mu, nnz_mu] + 5*([-nanstd(tmp_nnz,[],2), nanstd(tmp_nnz,[],2)] ./sqrt(size(tmp_rmse,2)));

lmax_ix = [5,6,1,2,3,4,5,6,1,2,3,4];

a = 0.5;
hold on
for ii = lmax_ix
   % PROB
   for iii = lmax_order
       plot(rmse_mean(prob_ix_low(iii)), nnz_mean(prob_ix_low(iii)),'o','markerfacecolor',c(lmax_ix(iii),:),'markeredgecolor','k','linewidth',0.5,'markersize',8)
       plot([rmse_ci(prob_ix_low(iii)); rmse_ci(prob_ix_high(iii))], [nnz_mu(prob_ix_low(iii)); nnz_mu(prob_ix_low(iii))],'-','color',[a a a],'linewidth',2)
       plot([rmse_mu(prob_ix_low(iii)); rmse_mu(prob_ix_low(iii))], [nnz_ci([prob_ix_low(iii)]);  nnz_ci(prob_ix_high(iii))],'-','color',[a a a],'linewidth',2)
   end
   
   % DET
   for iii = lmax_order
       plot(rmse_mean(det_ix_low(iii)), nnz_mean(det_ix_low(iii)),'s','markerfacecolor',c(lmax_ix(iii),:),'markeredgecolor','k','linewidth',0.5,'markersize',8)
       plot([rmse_ci(det_ix_low(iii)); rmse_ci([det_ix_high(iii)])], [nnz_mu(det_ix_low(iii)); nnz_mu(det_ix_low(iii))],'-','color',[a a a],'linewidth',2)
       plot([rmse_mu(det_ix_low(iii)); rmse_mu(det_ix_low(iii));], [nnz_ci(det_ix_low(iii)); nnz_ci([det_ix_high(iii)])],'-','color',[a a a],'linewidth',2)
   end
end
% TENSOR
plot(rmse_mean(ten_ix_low), nnz_mean(ten_ix_low),'d','markerfacecolor','w','markeredgecolor','k','linewidth',0.5,'markersize',8)
plot([rmse_ci(ten_ix_low); rmse_ci(ten_ix_high)], [nnz_mu(ten_ix_low); nnz_mu(ten_ix_low)],'-','color',[a a a],'linewidth',2)
plot([rmse_mu(ten_ix_low); rmse_mu(ten_ix_low)], [nnz_ci(ten_ix_low); nnz_ci(ten_ix_high)],'-','color',[a a a],'linewidth',2)

end

function c = getNiceColors(color_type)

dotest = false;
c1 = colormap(parula(32));
c2 = colormap(autumn(32));

if dotest
    figure('name','C1 color test');
    hold on
    for ii = 1:size(c1,1)
        plot(ii,1,'o','markerfacecolor',c1(ii,:),'markersize',12)
        text(ii-0.75,1,sprintf('%i',ii))
    end
    
    figure('name','C2 color test');
    hold on
    for ii = 1:size(c2,1)
        plot(ii,1,'o','markerfacecolor',c2(ii,:),'markersize',12)
        text(ii-0.75,1,sprintf('%i',ii))
    end
    keyboard
end

switch color_type
    case 'cold'
        c = [c1([1 3 6 9],:) ];
    case 'medium'
        c = [c1([12 16 19 23],:) ];
    case 'hot'
        %c = [c2([32 25 13 5],:)];
        c = [c2([32 27 19 12 2],:)];
        %c = [c2([32 28 22 18 12 2],:)];
end

end

function c = getNiceColors2()

dotest = false;
c = colormap(parula(64));


if dotest
    figure('name','C color test');
    hold on
    for ii = 1:size(c,1)
        plot(ii,1,'o','markerfacecolor',c(ii,:),'markersize',12)
        text(ii-0.75,1,sprintf('%i',ii))
    end
    
    keyboard
end

c = [c([1 8 20 40 50 64],:)];

end


