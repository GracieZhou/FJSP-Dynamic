%��ѡ�񡱲���  
function father_pool = choose_father(pop, pop_size, job, mac_num)  
[p,~,best_pop_n]=choose_prob(pop, job, mac_num);
father_pool = zeros(pop_size,length(pop));

% ������Ӣ����
father_pool(1,:) = pop(best_pop_n, :);

% ѡ���������壬���̶ķ�
for i = 2:pop_size
   r = rand;  %����һ�������  
   prand = p - r;  
   j = 1;
   while prand(j) < 0  
       j = j + 1;  
   end  
   father_pool(i,:) = pop(j,:); %ѡ�и�������  
end
