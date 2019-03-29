function [nb_mac] = mac_max_num(mac)
%UNTITLED8 此处显示有关此函数的摘要
%   此处显示详细说明
% 获取mac的个数
n = length(mac);
tmp = zeros(1,n);
for k = 1:n
    tmp(k) = max(mac{k});
end
nb_mac = max(tmp);
end

