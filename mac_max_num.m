function [nb_mac] = mac_max_num(mac)
%UNTITLED8 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ��ȡmac�ĸ���
n = length(mac);
tmp = zeros(1,n);
for k = 1:n
    tmp(k) = max(mac{k});
end
nb_mac = max(tmp);
end

