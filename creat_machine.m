%输入各类机器的数量
%输出一个一维元胞组，第i个元素是一个矩阵，代表了第i个机器的编号，如第一个机器有三个，则mac{1}=[1,2,3]
function [mac, mac_state]=creat_machine(mac_num)
num = 0;
mac = {};
mac_state = {};
for i = mac_num
    mac_serial = [];
    for j=1:i
        num=num+1;
        mac_serial=[mac_serial,num];
    end
    mac{end+1}=mac_serial;
    mac_state_s = ones(1,i);
    mac_state{end+1} = mac_state_s; 
end
end