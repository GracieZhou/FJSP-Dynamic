function [up_mac, up_mac_state] = UpdateMac(mac, mac_state, change_mac, flag)
%UpdateMac ����mac cell����
%   �˴���ʾ��ϸ˵��
up_mac = mac;
up_mac_state = mac_state;
% ɾ��mac��Ϣ
if flag == 'D'
    up_mac_state{change_mac(1)}(change_mac(2)) = 0; 
end

% ����mac��Ϣ
if flag == 'A'
    val = mac_max_num(mac);
    for i = 1:change_mac(2)
        up_mac{change_mac(1)}(end+1) = val+i;
        up_mac_state{change_mac(1)}(end+1) = 1;
    end
end

end

