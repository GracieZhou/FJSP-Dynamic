function [up_mac, up_mac_state] = UpdateMac(mac, mac_state, change_mac, flag)
%UpdateMac 更新mac cell内容
%   此处显示详细说明
up_mac = mac;
up_mac_state = mac_state;
% 删除mac信息
if flag == 'D'
    for i = 1:length(mac)
        for j = 1:length(mac{i})
            if change_mac == mac{i}(j)
                up_mac_state{i}(j) = 0; 
                break;
            end
        end
    end
end

% 增加mac信息
if flag == 'A'
    val = mac_max_num(mac);
    for i = 1:change_mac(2)
        up_mac{change_mac(1)}(end+1) = val+i;
        up_mac_state{change_mac(1)}(end+1) = 1;
    end
end

end

