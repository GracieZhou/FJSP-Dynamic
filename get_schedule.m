function [best_pop,best_time,mean_time] = get_schedule(gnmax, pc, pm, pop_size, job, mac_num)
%best_schedule 获取最优调度表
% 输入值：
%   gnmax 最大代数  
%   pc 交叉概率  
%   pm 变异概率
%   pop_size 初始化种群数量
%   job
%   mac_num
% 输出：
%   best_pop 最优种群
%   best_time 最优时间
%   mean_time 平均时间
global MIN_START_TIME
global MAX_END_TIME

pop = inipop(pop_size, job, mac_num);
best_time = zeros(1, gnmax);
mean_time = zeros(1, gnmax);
best_pop = zeros(gnmax, length(pop));

for generation = 1 : gnmax    
    father_pool = choose_father(pop, pop_size, job, mac_num);
    child_cross = cross_pox(father_pool, pc, job);
    child_mut = mutation_exchange(child_cross,pm, job, mac_num);
    [~, best_time(1, generation), best_pop_n, max_time_list] = choose_prob(child_mut, job, mac_num);
    
    % 在有效时间范围内才纳入最佳序列中
    if best_time(generation) > MIN_START_TIME && best_time(generation) <= MAX_END_TIME
        mean_time(1, generation) = mean(max_time_list);
        best_pop(generation,:) = child_mut(best_pop_n, :);
    end
end

end

