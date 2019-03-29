close all;
clear;
clc;

%===============================%
gnmax = 100; %������  
pc = 0.8; %�������  
pm = 0.1; %�������
pop_size = 10; %��ʼ����Ⱥ����
eventStartTime = 20; %������̬�¼���ʱ��
%===============================%

[job, mac_num] = read_data('hospitaldata.xlsx');
[mac, mac_state] = creat_machine(mac_num);

%-----------------------------------------------
% ��ȡ��Ѿ�̬����
%-----------------------------------------------
[best_pop, best_time, mean_time] = get_schedule(gnmax, pc, pm, pop_size, job, mac_num);
[minst_time, minst_n] = min(best_time);
best_schedule = best_pop(minst_n,:);
[max_mac_time, mac_serial, mac_start, mac_end] = decode(best_schedule, job, mac_num);

draw_gantt(max_mac_time, mac_serial, mac_start, mac_end, job, mac);

figure; 
plot(best_time,'r'); hold on;  
plot(mean_time,'b');
plot(minst_n, minst_time, 'og');
grid;  
title('��������');  
legend('���Ž�','ƽ����');  
xlabel('��������','FontName','΢���ź�','Color','b','FontSize',10)
ylabel('����ʱ��','FontName','΢���ź�','Color','b','FontSize',10,'Rotation',90)
hold off;

fprintf('�Ŵ��㷨�õ������ʱ��:%.2f\n',minst_time);  
fprintf('���ʱ���Ӧ�Ľ�������: %d\n', minst_n);


%-----------------------------------------------
% ִ�й����з�����̬�¼�
%-----------------------------------------------
fprintf('eventStartTime: %d, minst_time: %f\n', eventStartTime, minst_time);
if (eventStartTime > minst_time) || (minst_time == 0)
    fprintf('��̬�¼��ķ�����Ӱ���չ\n');
else
    % ��ȡ��̬��Ϣ
    [add_job, delete_job, add_mac, delete_mac] = read_changedata('changedata.xlsx');
    [exe_dynamic_flag, max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac] = dynamin(...
        mac_serial, mac_start, mac_end,...
        add_job, delete_job, add_mac, delete_mac,...
        eventStartTime, job, mac, mac_state);

    if exe_dynamic_flag
        draw_gantt(max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac);
        fprintf('��̬�滮��ȡ����������ʱ��:%.2f\n',max_mac_time);
    else
        fprintf('��̬�¼��ķ�����Ӱ���չ\n');
    end
    
end




