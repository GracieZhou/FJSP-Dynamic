function [best_pop,best_time,mean_time] = get_schedule(gnmax, pc, pm, pop_size, job, mac_num)
%best_schedule ��ȡ���ŵ��ȱ�
% ����ֵ��
%   gnmax ������  
%   pc �������  
%   pm �������
%   pop_size ��ʼ����Ⱥ����
%   job
%   mac_num
% �����
%   best_pop ������Ⱥ
%   best_time ����ʱ��
%   mean_time ƽ��ʱ��

pop = inipop(pop_size, job, mac_num);
best_time = zeros(1, gnmax);
mean_time = zeros(1, gnmax);
best_pop = zeros(gnmax, length(pop));

for generation = 1 : gnmax    
    father_pool = choose_father(pop, pop_size, job, mac_num);
    child_cross = cross_pox(father_pool, pc, job);
    child_mut = mutation_exchange(child_cross,pm, job, mac_num);
    [~, best_time(1, generation), best_pop_n, max_time_list] = choose_prob(child_mut, job, mac_num);
    mean_time(1, generation) = mean(max_time_list);
    best_pop(generation,:) = child_mut(best_pop_n, :);
end

end

