function [up_mac_serial, up_mac_start, up_mac_end] = delete_task(first, second, mac_serial, mac_start, mac_end)
%delete_task 删除[first, second]位置对应的task信息
%   此处显示详细说明
up_mac_serial = mac_serial;
up_mac_start = mac_start;
up_mac_end = mac_end;

if length(second) > 1
    ss = second(1);
    ee = second(2);
else
    ss = second;
    ee = second;
end
dd = ee-ss;

[row, ~] = size(mac_serial{first});
if row > 1
    serial_temp = zeros(row-1, 2);
    start_temp = zeros(1, row-1);
    end_temp = zeros(1, row-1);
    for i = 1:row
        if i < ss
            serial_temp(i,:) = mac_serial{first}(i,:);
            start_temp(i) = mac_start{first}(i);
            end_temp(i) = mac_end{first}(i);
        elseif i > ee
            serial_temp(i-1-dd,:) = mac_serial{first}(i,:);
            start_temp(i-1-dd) = mac_start{first}(i);
            end_temp(i-1-dd) = mac_end{first}(i);
        end
    end
else
    serial_temp = [];
    start_temp = [];
    end_temp = [];
end

up_mac_serial{first} = serial_temp;
up_mac_start{first} = start_temp;
up_mac_end{first} = end_temp;
end

