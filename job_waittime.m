function job_wait = job_waittime(mac_serial, mac_start, mac_end, job, mac)
%job_waittime 等待时间
%   
% 获取mac的个数
nb_mac = mac_max_num(mac);

% 获取job个数
job_num = length(job);

job_start = cell(1,job_num);
job_end = cell(1,job_num);
for i = 1:job_num
    job_start{i} = zeros(1, length(job{i}));
    job_end{i} = zeros(1, length(job{i}));
end

job_wait = zeros(1,job_num);

for i=1:nb_mac
    for j=1:length(mac_start{i})
        job_start{mac_serial{i}(j,1)}(mac_serial{i}(j,2)) = mac_start{i}(j);
        job_end{mac_serial{i}(j,1)}(mac_serial{i}(j,2)) = mac_end{i}(j);
    end
end
        
for k = 1:job_num
    for j = 2:length(job_start{k})
        if job_start{k}(j) > job_end{k}(j-1)
            job_wait(1,k) = job_wait(1,k) + job_start{k}(j) - job_end{k}(j-1);
        end
    end
end

end

