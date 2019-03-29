function [flag, max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac] = dynamin(...
    mac_serial, mac_start, mac_end,...
    add_job, delete_job, add_mac, delete_mac,...
    eventStartTime, job, mac, mac_state)
%dynamin ��̬�滮
%   ���ݻ�ȡ��job �� mac�Ķ�̬�仯��Ϣ����mac_serial, mac_start, mac_end��job�б���и���

% ��̬�¼����ͺ���Ҫ�����job list,��һ����job��ţ��ڶ����Ƕ�Ӧ�Ĺ���ţ������������翪ʼʱ��
todo_job_list = [];

% ɾ��ĳ���ߺ����׶�
if ~isempty(delete_job)
    [num, ~] = size(delete_job);
    for i = 1:num
        [first, second] = find_job_coord(mac_serial, delete_job(i,:));
        if first>0
            temp_time = mac_start{first}(1,second);
            if temp_time > eventStartTime
                flag = true;
                [mac_serial, mac_start, mac_end] = delete_task(first, second, mac_serial, mac_start, mac_end);
                Tot = length(job{delete_job(i,1)});
                if delete_job(i,2)<Tot
                    for n = delete_job(i,2)+1:Tot
                        [first, second] = find_job_coord(mac_serial, [delete_job(i,1),n]);
                        [mac_serial, mac_start, mac_end] = delete_task(first, second, mac_serial, mac_start, mac_end);
                    end
                end
            end
        end
    end
end

% ��������
if ~isempty(add_job)
    flag = true;
    N = length(job);
    for i = 1:length(add_job)
        job_start_time = eventStartTime;
        for j = 1:length(add_job{i})
            if j > 1
                job_start_time = job_start_time + add_job{i}{j-1}(1);
            end
            todo_job_list(end+1,:) = [N+i, j, job_start_time];
        end
    end
    update_job = [job, add_job];
end

% ɾ��ĳ��ҽ����Դ
if ~isempty(delete_mac)
    [num, ~] = size(delete_mac);
    for i = 1:num
        [~, mac_state] = UpdateMac(mac, mac_state, delete_mac, 'D');
        mac_pos = mac{delete_mac(1)}(delete_mac(2));
        [row, ~] = size(mac_serial{mac_pos});
        for j = 1:row
            if mac_start{mac_pos}(j) >= eventStartTime
                flag = true;
                tmptime = eventStartTime;
                % ����ǰһ����������ʱ��
                if mac_serial{mac_pos}(j,2) > 1
                    pre_task = [mac_serial{mac_pos}(j,1),mac_serial{mac_pos}(j,2)-1];
                    [first, second] = find_job_coord(mac_serial, pre_task);
                    if first > 0
                        tmptime = max(mac_end{first}(second), eventStartTime);
                    end
                end
                
                % ��Ӱ�쵽��job�ĺ������򶼼���todo��
                Tot = length(job{mac_serial{mac_pos}(j,1)});
                for n = mac_serial{mac_pos}(j,2):Tot
                    job_time = 0;
                    if n > mac_serial{mac_pos}(j,2)
                        job_time = job{mac_serial{mac_pos}(j,1)}{n-1}(1);
                    end
                    todo_job_list(end+1,:) = [mac_serial{mac_pos}(j,1), n, tmptime+job_time];  
                end
            end  
        end
    end
end

% ����ĳЩҽ����Դ
if ~isempty(add_mac)
    [row, ~] = size(add_mac);
    for i = 1:row
        [mac, mac_state] = UpdateMac(mac, mac_state, add_mac, 'A');
        mac_serial = [mac_serial, cell(1, add_mac(2))];
        mac_start = [mac_start, cell(1, add_mac(2))];
        mac_end = [mac_end, cell(1, add_mac(2))];
    end
end

% todo list ȥ�أ���ɾ����Ӧ��task
if ~isempty(todo_job_list)
    todo_job_list = unique(todo_job_list, 'rows');
    [row, ~] = size(todo_job_list);
    for i = 1:row
        [first, second] = find_job_coord(mac_serial, [todo_job_list(i,1), todo_job_list(i,2)]);
        if first > 0
            [mac_serial, mac_start, mac_end] = delete_task(first, second, mac_serial, mac_start, mac_end);
        end
    end
    
    % ��̬�����Ӧ������
    [max_mac_time, mac_serial, mac_start, mac_end] = dynamic_insert...
        (todo_job_list, mac_serial, mac_start, mac_end, update_job, mac, mac_state);
    up_mac_serial = mac_serial;
    up_mac_start = mac_start;
    up_mac_end = mac_end;
    update_mac = mac;
end

end

