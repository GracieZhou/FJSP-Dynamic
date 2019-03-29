function [max_mac_time, mac_serial, mac_start, mac_end] = dynamic_insert(...
    job_serial, mac_serial, mac_start, mac_end, job, mac, mac_state)
%dynamic_insert 动态插入
%   
[n, ~] = size(job_serial);
job_start = cell(1, length(job));
job_end = cell(1, length(job));

for i=1:n
    %此部分求出第i号工序加工机器:the_mac
    the_mac_type = job{job_serial(i,1)}{job_serial(i,2)}(2);
    if length(mac{the_mac_type}) < 1
        sprintf('the_mac_type = %d 对应的资源不存在', the_mac_type);
        continue;
    end
    find_mac = mac{the_mac_type};
    find_mac_len = length(find_mac);
    
    %求出工件开始时间（不是真正的开始时间）
    if isempty(job_start{job_serial(i,1)})
        if job_serial(i,2) > 1
            job_start{job_serial(i,1)} = zeros(1, job_serial(i,2)-1);
            job_end{job_serial(i,1)} = zeros(1, job_serial(i,2)-1);
            % 设置前一个任务的结束时间（结束时间即和该任务的开始时间一致）
            job_end{job_serial(i,1)}(end) = job_serial(i,3);
        end
        job_start{job_serial(i,1)}(end+1) = job_serial(i,3);
    else
        job_start{job_serial(i,1)}(end+1) = job_end{job_serial(i,1)}(job_serial(i,2)-1);
    end
    
    %将第i个工序插入到机器中加工，如果机器间隔合适，插入间隔中，如不合适，插入到结束时间最早的机器最后一位
    insert_flag = false;
    for k = 1:find_mac_len
        % 跳过状态为不可用的mac
        if mac_state{the_mac_type}(k) == 0
            continue;
        end
        
        the_mac = find_mac(k);
        % mac_serial 序列为空，则直接插入
        if isempty(mac_serial{the_mac})
            mac_serial{the_mac}(end+1,:) = [job_serial(i,1) job_serial(i,2)];
            mac_start{the_mac}(end+1) = max([job_end{job_serial(i,1)}(end), 0],[],'omitnan');
            mac_end{the_mac}(end+1) = mac_start{the_mac}(end) + job{job_serial(i,1)}{job_serial(i,2)}(1);
            job_end{job_serial(i,1)}(end+1) = mac_end{the_mac}(end);
            insert_flag = true;
            break;
        end
        
        [mac_start{the_mac}, mac_end{the_mac},job_end_time, insert_pot] = insert_mac(...
            mac_start{the_mac},mac_end{the_mac},...
            job_start{job_serial(i,1)}(job_serial(i,2)),...
            job_end{job_serial(i,1)},...
            job{job_serial(i,1)}{job_serial(i,2)}(1),...
            false);

        if insert_pot > 0
            insert_flag = true;
            mac_serial{the_mac} = [mac_serial{the_mac}(1:insert_pot-1,:); [job_serial(i,1) job_serial(i,2)]; mac_serial{the_mac}(insert_pot:end,:)];
            job_end{job_serial(i,1)}(end+1) = job_end_time;
            break;
        end
    end
    
    % 插入到最早结束mac的尾部
    if ~insert_flag
        temp = [];
        for k = 1:find_mac_len
            % 跳过状态为不可用的mac
            if mac_state{the_mac_type}(k) == 0
                temp(end+1) = NaN;
                continue;
            end
            the_mac = find_mac(k);
            if ~isempty(mac_end{the_mac})
                temp(end+1) = max(mac_end{the_mac});
            end
        end
        [~, index] = min(temp, [], 'omitnan');
        insert_mac_index = find_mac(index);
        mac_serial{insert_mac_index} = [mac_serial{insert_mac_index}(1:end,:); [job_serial(i,1) job_serial(i,2)]];
        mac_start{insert_mac_index}(end+1) = max([mac_end{insert_mac_index}(end),job_end{job_serial(i,1)}(end), 0],[],'omitnan');
        mac_end{insert_mac_index}(end+1) = mac_start{insert_mac_index}(end) + job{job_serial(i,1)}{job_serial(i,2)}(1);
        job_end{job_serial(i,1)}(end+1) = mac_end{insert_mac_index}(end);
    end
end

%求出机器最大完工时间
max_mac_time=0;
nb_mac = mac_max_num(mac);
for i=1:nb_mac
    if ~isempty(mac_end{i})
        max_mac_time = max(max_mac_time,max(mac_end{i}));
    end
end
end

