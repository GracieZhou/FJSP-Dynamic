%输入某机器的开始时间和结束时间（一维）
%输出间隔时间（一维），从1，2工序的间隔开始，如果没有间隔即为0
function [mac_start,mac_end,job_end_time,insert_pot] = insert_mac(...
    mac_start, mac_end, job_start, job_end, job_time, is_insert_tail)

% 设置初始值
job_end_time = job_start + job_time;
insert_pot = -1;

if length(mac_start) >= 2
    for i = 2:length(mac_start)        
        mac_interval = mac_start(i) - mac_end(i-1);
        find_start = max(mac_end(i-1),job_start);
        if mac_interval>=job_time && find_start+job_time<=mac_start(i)
            mac_start = [mac_start(1:i-1), find_start, mac_start(i:end)];
            mac_end = [mac_end(1:i-1), find_start+job_time, mac_end(i:end)];
            job_end_time = find_start + job_time;
            insert_pot = i;
            return
        end        
    end
end

if is_insert_tail
    mac_start(end+1) = max([mac_end, job_end, 0], [], 'omitnan');
    mac_end(end+1) = mac_start(end) + job_time;
    job_end_time = mac_start(end) + job_time;
    insert_pot = length(mac_start);
end
end
