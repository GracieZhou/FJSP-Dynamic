close all;
clear;
clc;
global MIN_START_TIME
global MAX_END_TIME
MIN_START_TIME = 8;
MAX_END_TIME = 18;

%===============================%
gnmax = 50; %������  
pc = 0.8; %�������  
pm = 0.1; %�������
pop_size = 10; %��ʼ����Ⱥ����
eventStartTime = 10; %������̬�¼���ʱ��
%===============================%

[job, mac_num] = read_data('hospitaldata.xlsx');
[mac, mac_state] = creat_machine(mac_num);

%-----------------------------------------------
% ��ȡ�Ƚ��ȳ�����
%-----------------------------------------------
pop = inipop(1, job, mac_num);
[f_mac_time, f_mac_serial, f_mac_start, f_mac_end] = decode(pop, job, mac_num);
draw_gantt(f_mac_time, f_mac_serial, f_mac_start, f_mac_end, job, mac, 0);
fprintf('�Ƚ��ȳ��������ʱ��:%.2f\n',f_mac_time);
f_job_wait = job_waittime(f_mac_serial, f_mac_start, f_mac_end, job, mac);
fprintf('�Ƚ��ȳ������û��ȴ�ʱ��:\n');
f_job_wait

if 1
%-----------------------------------------------
% ��ȡ��Ѿ�̬����
%-----------------------------------------------
[best_pop, best_time, mean_time] = get_schedule(gnmax, pc, pm, pop_size, job, mac_num);
if length(best_time) < 1
    fprintf('�Ŵ��㷨δѰ�ҵ���Ѳ��ԣ�����������������Ϣ\n');
else
    [minst_time, minst_n] = min(best_time);
    best_schedule = best_pop(minst_n,:);
    [max_mac_time, mac_serial, mac_start, mac_end] = decode(best_schedule, job, mac_num);

    draw_gantt(max_mac_time, mac_serial, mac_start, mac_end, job, mac, 0);

    figure; 
    plot(best_time,'r'); hold on;  
    plot(mean_time,'b');
    plot(minst_n, minst_time, 'og');
    grid;  
    title('��������');  
    legend('���Ž�','ƽ����');  
    axis([0, gnmax+5, 8, 20]);%x�� y��ķ�Χ
    xlabel('��������','FontName','΢���ź�','Color','b','FontSize',10)
    ylabel('����ʱ��','FontName','΢���ź�','Color','b','FontSize',10,'Rotation',90)
    hold off;

    fprintf('�Ŵ��㷨�õ������ʱ��:%.2f\n',minst_time);  
    fprintf('���ʱ���Ӧ�Ľ�������: %d\n', minst_n);
    job_wait = job_waittime(mac_serial, mac_start, mac_end, job, mac);
    fprintf('�Ŵ��㷨��̬�����û��ȴ�ʱ��:\n');
    job_wait
    
    %-----------------------------------------------
    % ִ�й����з�����̬�¼�
    %-----------------------------------------------
    fprintf('eventStartTime: %d, minst_time: %f\n', eventStartTime, minst_time);
    if (eventStartTime > MAX_END_TIME) || (eventStartTime < MIN_START_TIME)
        fprintf('��̬�¼��ķ�����Ӱ���չ\n');
    else
        % ��ȡ��̬��Ϣ
        [add_job, delete_job, add_mac, delete_mac] = read_changedata('changedata.xlsx');
        [exe_dynamic_flag, d_max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac, over_time_job] = dynamin(...
            mac_serial, mac_start, mac_end,...
            add_job, delete_job, add_mac, delete_mac,...
            eventStartTime, job, mac, mac_state);

        if exe_dynamic_flag
            if ~isempty(over_time_job)
                fprintf('���ڹ滮���������¼�������ʼʱ�䣬���δ�ܶ�����task���й滮\n');
                [row, ~] = size(over_time_job);
                for i = 1:row
                    fprintf('����[%d,%d]�� �滮ʱ��[%.2f, %.2f]�� ����ʱ��[%.2f, %.2f]\n', over_time_job(i,1),...
                        over_time_job(i,2), over_time_job(i,3), over_time_job(i,4), over_time_job(i,5), over_time_job(i,6));
                end
            end
            
            draw_gantt(d_max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac, eventStartTime);
            fprintf('��̬�滮��ȡ����������ʱ��:%.2f\n',d_max_mac_time);
            d_job_wait = job_waittime(up_mac_serial, up_mac_start, up_mac_end, job, mac);
            fprintf('��̬�����û��ȴ�ʱ��:\n');
            d_job_wait
        else
            fprintf('��̬�¼��ķ�����Ӱ���չ\n');
        end

    end
end
end



