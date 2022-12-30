function EstimateGLM
% List of open inputs
filepath = spm_select(inf,'dir','Select output directory');
filepath_list = dir(filepath);
for i=1:size(filepath_list, 1)-2
    subpath = strcat(filepath, filepath_list(i+2).name, '\');
    cd(subpath);
    jobmat = [subpath 'SPM.mat'];
    matlabbatch{1}.spm.stats.fmri_est.spmmat = {jobmat};
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    save ('EstimateGLM.mat',  'matlabbatch');
    nrun = 1; % enter the number of runs here
    jobmat1=[subpath 'EstimateGLM.mat'];
    jobfile = {jobmat1};
    jobs = repmat(jobfile, 1, nrun);
    inputs = cell(0, nrun);
    for crun = 1:nrun
    end
    spm('defaults', 'FMRI');
    spm_jobman('serial', jobs, '', inputs{:});
     
    cd(filepath);
end
end
