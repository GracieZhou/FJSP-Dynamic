%����ĳ�����Ŀ�ʼʱ��ͽ���ʱ�䣨һά��
%������ʱ�䣨һά������1��2����ļ����ʼ�����û�м����Ϊ0
function [mac_start,mac_end,insert_pot]=find_interval(mac_start,mac_end,job_start,job_time)

if length(mac_start)>=2
    for i=2:length(mac_start)
        mac_interval=mac_start(i)-mac_end(i-1);
        if mac_interval>=job_time && max(mac_end(i-1),job_start)+job_time<=mac_start(i)
            find_start=max(mac_end(i-1),job_start);
            mac_start=[mac_start(1:i-1),find_start,mac_start(i:end)];
            mac_end=[mac_end(1:i-1),find_start+job_time,mac_end(i:end)];
            insert_pot=i;
            return
        end        
    end
    mac_start(end+1)=max(mac_end(end),job_start);
    mac_end(end+1)=mac_start(end)+job_time;
    insert_pot=length(mac_start);
end