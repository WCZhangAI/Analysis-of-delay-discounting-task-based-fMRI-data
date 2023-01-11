function GLM_Specify
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load('DDT_TP_OB.mat');                                            

workpath = spm_select(inf,'dir','Select work directory');
outpath =  spm_select(inf,'dir','Select output directory');
rp_path = spm_select(inf,'dir','select rp file directory');

cd(workpath);
workpath_list = dir;
nsub = size(workpath_list,1) - 2;
for i = 1 : nsub
    outpath_sub = strcat(outpath, workpath_list(i+2).name, '\');
    mkdir(outpath_sub);
    
    work_path_temp = strcat(workpath, workpath_list(i+2).name);
    work_path = strcat(work_path_temp, '\', 's*.nii');
    
    rp_path_temp = strcat(rp_path, workpath_list(i+2).name, '\', 'rp_*.txt');
    rp = dir(rp_path_temp);
    rp = {strcat(rp_path, workpath_list(i+2).name, '\', rp.name)};
    
    %% Time Point
    subfile = regexp(workpath_list(i+2).name, '-', 'split');
    subnum = subfile{1};   % Sub number
    tp_info = DDT_TP_all.(subnum);    
    num = str2num(subnum(4:end));
    TP = str2num(subfile{2}(1));  % 1: Pre£¬ 2: Post1
    temp = strcat('TP', num2str(num), '_', num2str(TP));
    tp_info = tp_info.(temp);
    subfile = regexp(workpath_list(i+2).name, '_', 'split');
    numRun = subfile{2};
    tp_info = tp_info.(numRun);

    %%
    clear matlabbatch      
    matlabbatch{1}.spm.stats.fmri_spec.dir = {outpath_sub};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    %% Run1
    list=dir(work_path);    
    for j=1:size(list,1)
         Imgname = strcat(work_path_temp, '\', list(j,1).name, ',1');
         matlabbatch{1}.spm.stats.fmri_spec.sess.scans{j,1} = Imgname;
    end
    
    Ans_TP_all = tp_info.Ans_TP;
    FB_TP_all = tp_info.FB_TP;
    RT_all = (tp_info.RT)/1000;  
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'Hard';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = Ans_TP_all(tp_info.hard_trial);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = RT_all(tp_info.hard_trial);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
  
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'Easy';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = Ans_TP_all(tp_info.easy_trial);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = RT_all(tp_info.easy_trial);
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'FB';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = FB_TP_all;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = 2;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = rp;
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    %%
    cd(outpath_sub);
    save ('GLM.mat', 'matlabbatch');
    jobmat = [outpath_sub 'GLM.mat'];
    nrun = 1; 
    jobfile = {jobmat};
    jobs = repmat(jobfile, 1, nrun);
    inputs = cell(0, nrun);
    for crun = 1:nrun
    end
    spm('defaults', 'FMRI');
    spm_jobman('serial', jobs, '', inputs{:});
    
    cd(workpath);
     
end

end

