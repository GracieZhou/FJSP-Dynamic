function [job,mac_num] = read_data(file_name)
data_job = xlsread(file_name,1);
job_col = 4;
job = cell(1,size(data_job,2)/job_col);
for i = 1:job_col:size(data_job,2)
    for j = 1:size(data_job,1)
        if ~ismissing(data_job(j,i))
            job{(i+(job_col)-1)/job_col}{j} = data_job(j, i:i+(job_col-1));
        end
    end
end
mac_num=xlsread(file_name,2);