filepath = spm_select(inf,'dir','Select work directory');
cd(filepath);
filepath_list = dir(filepath);

for i=1:size(filepath_list, 1)-2
    subpath = strcat(filepath, filepath_list(i+2).name, '\');
    cd(subpath);
    clear jobs
    jobs{1}.stats{1}.con.spmmat = cellstr(fullfile(subpath,'SPM.mat'));
    jobs{1}.stats{1}.con.consess{1}.tcon.name = 'SIR';
    jobs{1}.stats{1}.con.consess{1}.tcon.convec = [1];
    jobs{1}.stats{1}.con.delete = 0;
           
    jobs{1}.stats{1}.con.consess{2}.tcon.name = 'LDR';
    jobs{1}.stats{1}.con.consess{2}.tcon.convec = [0 1];
    jobs{1}.stats{1}.con.delete = 0;
    
    jobs{1}.stats{1}.con.consess{3}.tcon.name = 'LDR-SIR';
    jobs{1}.stats{1}.con.consess{3}.tcon.convec = [-1 1];
    jobs{1}.stats{1}.con.delete = 0;

    jobs = spm_jobman('spm5tospm8',{jobs});
    spm_jobman('run',jobs);
           
end