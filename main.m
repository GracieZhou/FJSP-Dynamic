close all;
clear;
clc;

%===============================%
gnmax = 100; %最大代数  
pc = 0.8; %交叉概率  
pm = 0.1; %变异概率
pop_size = 10; %初始化种群数量
eventStartTime = 20; %发生动态事件的时刻
%===============================%

[job, mac_num] = read_data('hospitaldata.xlsx');
[mac, mac_state] = creat_machine(mac_num);

%-----------------------------------------------
% 获取最佳静态策略
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
title('搜索过程');  
legend('最优解','平均解');  
xlabel('进化代数','FontName','微软雅黑','Color','b','FontSize',10)
ylabel('处理时长','FontName','微软雅黑','Color','b','FontSize',10,'Rotation',90)
hold off;

fprintf('遗传算法得到的最短时间:%.2f\n',minst_time);  
fprintf('最短时间对应的进化代数: %d\n', minst_n);


%-----------------------------------------------
% 执行过程中发生动态事件
%-----------------------------------------------
fprintf('eventStartTime: %d, minst_time: %f\n', eventStartTime, minst_time);
if (eventStartTime > minst_time) || (minst_time == 0)
    fprintf('动态事件的发生不影响进展\n');
else
    % 获取动态信息
    [add_job, delete_job, add_mac, delete_mac] = read_changedata('changedata.xlsx');
    [exe_dynamic_flag, max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac] = dynamin(...
        mac_serial, mac_start, mac_end,...
        add_job, delete_job, add_mac, delete_mac,...
        eventStartTime, job, mac, mac_state);

    if exe_dynamic_flag
        draw_gantt(max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac);
        fprintf('动态规划获取到的最短完成时间:%.2f\n',max_mac_time);
    else
        fprintf('动态事件的发生不影响进展\n');
    end
    
end




