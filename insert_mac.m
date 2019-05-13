%����ĳ�����Ŀ�ʼʱ��ͽ���ʱ�䣨һά��
%������ʱ�䣨һά������1��2����ļ����ʼ�����û�м����Ϊ0
function [mac_start,mac_end,job_end_time,insert_pot] = insert_mac(...
    mac_start, mac_end, job_start, job_end, job_time, min_start, max_end, is_insert_tail)

% ���ó�ʼֵ
job_end_time = job_start + job_time;
insert_pot = -1;

if ~is_insert_tail
    % �������п�ʼǰ
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

% �������е��м�
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

% ��������β��
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
