% Add the path to the gPPPI toolbox. 
spmpath=fileparts(which('spm.m'));
addpath([spmpath filesep 'toolbox']);
addpath([spmpath filesep 'toolbox' filesep 'PPPI']);
spm('defaults','fmri')

% Set up the control param structure P which determines the run
workdir = spm_select(inf,'dir','Select work directory');

cd(workdir);
path_temp = dir;
path_sub = [];
for i=1:size(path_temp,1) 
    if path_temp(i).isdir ==1
       path_sub =[path_sub; path_temp(i)];
    end
end
MYV.subjects = [];
for i=3:length(path_sub)    
    MYV.subjects = [MYV.subjects, {path_sub(i).name}];
end

for i=1: length(MYV.subjects)
P.subject='NW';                                          % group name
P.directory = [workdir MYV.subjects{i}];  
P.VOI = 'F:\SPM_Process\DDT_Pre_Post1_Pair_20200721\GLM_20211216_SIR_LDR\GLM_20211216\PairT_Pre-Post_20211217\PPI_20211218\SIR_Pre-Post_Caudate_R\SIR_Pre-Post_Caudate_R.img';  % Seed region
P.Region='SIR_Pre-Post_Caudate_R';                              % Seed name
P.analysis='psy';
P.method='cond';
P.Estimate=1;
P.contrast=0;
P.extract='eig';
P.Tasks={'0' 'SIR' 'LDR'};
P.Weights=[];
P.equalroi=1;
P.FLmask=0;
P.CompContrasts=1;

% P.maskdir='';
P.Contrasts(1).name='LDR-SIR';
P.Contrasts(1).left={'LDR'};
P.Contrasts(1).right={'SIR'};
P.Contrasts(1).MinEvents=30;
P.Contrasts(1).STAT='T';

P.Contrasts(2).name='LDR';
P.Contrasts(2).left={'LDR'};
P.Contrasts(2).right= {'none'};
P.Contrasts(2).MinEvents=30;
P.Contrasts(2).STAT='T';

P.Contrasts(3).name='SIR';
P.Contrasts(3).left={'SIR'};
P.Contrasts(3).right= {'none'};
P.Contrasts(3).MinEvents=30;
P.Contrasts(3).STAT='T';

PPPI(P, [workdir filesep 'SIR_Pre-Post_Caudate_R' filesep 'gPPITest.mat']);     % *** mask名称 注意更改 ***
end


