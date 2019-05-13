%输入某机器的开始时间和结束时间（一维）
%输出间隔时间（一维），从1，2工序的间隔开始，如果没有间隔即为0
function [mac_start,mac_end,job_end_time,insert_pot] = insert_mac(...
    mac_start, mac_end, job_start, job_end, job_time, min_start, max_end, is_insert_tail)

% 设置初始值
job_end_time = job_start + job_time;
insert_pot = -1;

if ~is_insert_tail
    % 插入序列开始前
    if ~isempty(mac_start)
        find_start = max(job_start, min_start);
        find_end = find_start + job_time;
        if find_end <= min(mac_start(1), max_end)
            mac_start = [find_start, mac_start];
            mac_end = [find_end, mac_end];
            job_end_time = find_end;
            insert_pot = 1;
            return;
        end
    end
end

% 插入序列的中间
if length(mac_start) >= 2
    for i = 2:length(mac_start)  
        mac_interval = mac_start(i) - mac_end(i-1);
        find_start = max([mac_end(i-1), job_start, min_start], [], 'omitnan');
        find_end = find_start + job_time;
        if mac_interval >= job_time && find_end <= min(mac_start(i),max_end)
            mac_start = [mac_start(1:i-1), find_start, mac_start(i:end)];
            mac_end = [mac_end(1:i-1), find_end, mac_end(i:end)];
            job_end_time = find_end;
            insert_pot = i;
            return
        end        
    end
end

% 插入序列尾部
if is_insert_tail
    find_start = max([mac_end, job_end, min_start], [], 'omitnan');
    find_end = find_start + job_time;
    if find_end <= max_end
        mac_start(end+1) = find_start;
        mac_end(end+1) = find_end;
        job_end_time = mac_end(end);
        insert_pot = length(mac_start);
    end
end
end
