%“选择”操作  
function father_pool = choose_father(pop, pop_size, job, mac_num)  
[p,~,best_pop_n]=choose_prob(pop, job, mac_num);
father_pool = zeros(pop_size,length(pop));

% 保留精英个体
father_pool(1,:) = pop(best_pop_n, :);

% 选择其他个体，轮盘赌法
for i = 2:pop_size
   r = rand;  %产生一个随机数  
   prand = p - r;  
   j = 1;
   while prand(j) < 0  
       j = j + 1;  
   end  
   father_pool(i,:) = pop(j,:); %选中个体的序号  
end
