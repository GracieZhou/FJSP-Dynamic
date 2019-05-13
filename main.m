close all;
clear;
clc;
global MIN_START_TIME
global MAX_END_TIME
MIN_START_TIME = 8;
MAX_END_TIME = 18;

%===============================%
gnmax = 50; %最大代数  
pc = 0.8; %交叉概率  
pm = 0.1; %变异概率
pop_size = 10; %初始化种群数量
eventStartTime = 10; %发生动态事件的时刻
%===============================%

[job, mac_num] = read_data('hospitaldata.xlsx');
[mac, mac_state] = creat_machine(mac_num);

%-----------------------------------------------
% 获取先进先出策略
%-----------------------------------------------
pop = inipop(1, job, mac_num);
[f_mac_time, f_mac_serial, f_mac_start, f_mac_end] = decode(pop, job, mac_num);
draw_gantt(f_mac_time, f_mac_serial, f_mac_start, f_mac_end, job, mac, 0);
fprintf('先进先出策略完成时间:%.2f\n',f_mac_time);
f_job_wait = job_waittime(f_mac_serial, f_mac_start, f_mac_end, job, mac);
fprintf('先进先出策略用户等待时间:\n');
f_job_wait

if 1
%-----------------------------------------------
% 获取最佳静态策略
%-----------------------------------------------
[best_pop, best_time, mean_time] = get_schedule(gnmax, pc, pm, pop_size, job, mac_num);
if length(best_time) < 1
    fprintf('遗传算法未寻找到最佳策略，请调整输入的数据信息\n');
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
    title('搜索过程');  
    legend('最优解','平均解');  
    axis([0, gnmax+5, 8, 20]);%x轴 y轴的范围
    xlabel('进化代数','FontName','微软雅黑','Color','b','FontSize',10)
    ylabel('处理时长','FontName','微软雅黑','Color','b','FontSize',10,'Rotation',90)
    hold off;

    fprintf('遗传算法得到的最短时间:%.2f\n',minst_time);  
    fprintf('最短时间对应的进化代数: %d\n', minst_n);
    job_wait = job_waittime(mac_serial, mac_start, mac_end, job, mac);
    fprintf('遗传算法静态策略用户等待时间:\n');
    job_wait
    
    %-----------------------------------------------
    % 执行过程中发生动态事件
    %-----------------------------------------------
    fprintf('eventStartTime: %d, minst_time: %f\n', eventStartTime, minst_time);
    if (eventStartTime > MAX_END_TIME) || (eventStartTime < MIN_START_TIME)
        fprintf('动态事件的发生不影响进展\n');
    else
        % 获取动态信息
        [add_job, delete_job, add_mac, delete_mac] = read_changedata('changedata.xlsx');
        [exe_dynamic_flag, d_max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac, over_time_job] = dynamin(...
            mac_serial, mac_start, mac_end,...
            add_job, delete_job, add_mac, delete_mac,...
            eventStartTime, job, mac, mac_state);

        if exe_dynamic_flag
            if ~isempty(over_time_job)
                fprintf('由于规划方案超出事件的最晚开始时间，因此未能对以下task进行规划\n');
                [row, ~] = size(over_time_job);
                for i = 1:row
                    fprintf('患者[%d,%d]， 规划时段[%.2f, %.2f]， 期望时段[%.2f, %.2f]\n', over_time_job(i,1),...
                        over_time_job(i,2), over_time_job(i,3), over_time_job(i,4), over_time_job(i,5), over_time_job(i,6));
                end
            end
            
            draw_gantt(d_max_mac_time, up_mac_serial, up_mac_start, up_mac_end, update_job, update_mac, eventStartTime);
            fprintf('动态规划获取到的最短完成时间:%.2f\n',d_max_mac_time);
            d_job_wait = job_waittime(up_mac_serial, up_mac_start, up_mac_end, job, mac);
            fprintf('动态策略用户等待时间:\n');
            d_job_wait
        else
            fprintf('动态事件的发生不影响进展\n');
        end

    end
end
end



