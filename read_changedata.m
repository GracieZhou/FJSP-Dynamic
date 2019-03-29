function [add_job,delete_job,add_mac,delete_mac] = read_changedata(file_name)
%read_changedata 解析变化数据表格
%   此处显示详细说明
data_job = xlsread(file_name,1);
add_job=cell(1,size(data_job,2)/2);
for i=1:2:size(data_job,2)
    for j=1:size(data_job,1)
        if ~ismissing(data_job(j,i))
            add_job{(i+1)/2}{j}=data_job(j,i:i+1);
        end
    end
end
delete_job = xlsread(file_name,2);
add_mac = xlsread(file_name,3);
delete_mac = xlsread(file_name,4);
end

