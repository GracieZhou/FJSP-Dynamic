function [first, second] = find_job_coord(mac_serial, delete_job)
%find_job_coord ����delete_job��mac_serial�е�λ��
%   �˴���ʾ��ϸ˵��
mac_num = length(mac_serial);
first = -1;
second = -1;
for i = 1:mac_num
    [row, ~] = size(mac_serial{i});
    for j = 1:row
        if isequal(mac_serial{i}(j,:), delete_job)
            first = i;
            second = j;
        end
    end
end

end

