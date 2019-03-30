%���룺����
%�������ά��������i��Ӧԭ�����е�i��Ԫ�أ���һ�ж�Ӧ�������ڶ��ж�Ӧ�ù����Ĺ���
function [max_mac_time,mac_serial,mac_start,mac_end]=decode(code, job, mac_num)
mac = creat_machine(mac_num);
n=length(code)/2;%����������
%�������ɹ������У���ά���󣬵�i��Ϊ����ĵ�i�����򣬵�һ��Ϊ�������ţ��ڶ���Ϊ�������
job_serial=[];
for i=1:n
    job_serial(end+1,:)=[code(i),sum(code(1:i)==code(i))];
end
%�������ɻ������У�Ԫ���飬���ڵ�i��Ԫ����Ϊ�������ţ��ڲ��ǰ����Ⱥ�˳��Ĺ��������������ʽΪjob_serial��ʽ
%�������ɻ���������ʼ������ʱ�䣬������ʼ������ʱ��
mac_serial=cell(1,sum(mac_num));
job_start=cell(1,length(job));
job_end=cell(1,length(job));
mac_start=cell(1,sum(mac_num));
mac_end=cell(1,sum(mac_num));
overtime = [];
for i=1:n
    %�˲��������i�Ź���ӹ�����:the_mac
    the_mac_type=job{job_serial(i,1)}{job_serial(i,2)}(2);
    job_in_mac_code=0;
    for j=1:job_serial(i,1)-1
        job_in_mac_code=job_in_mac_code+length(job{j});
    end
    job_in_mac_code=job_in_mac_code+job_serial(i,2)+n;
    the_mac=mac{the_mac_type}(code(job_in_mac_code));
    
    %���������ʼʱ�䣨���������Ŀ�ʼʱ�䣩
    if job_serial(i,2)==1
        job_start{job_serial(i,1)}(1) = job{job_serial(i,1)}{1}(3); %���翪ʼʱ��
    else
        job_start{job_serial(i,1)}(end+1)=job_end{job_serial(i,1)}(job_serial(i,2)-1);
    end
    
    %����i��������뵽�����мӹ����������������ʣ��������У��粻���ʣ����뵽���һλ
    %��һ�����⣬jobserialû�е�˳�򣬽ṹ�����Ż�
    [mac_start{the_mac},mac_end{the_mac},job_end_time,insert_pot] = insert_mac(...
        mac_start{the_mac},...
        mac_end{the_mac},...
        job_start{job_serial(i,1)}(job_serial(i,2)),...
        job_end{job_serial(i,1)},...
        job{job_serial(i,1)}{job_serial(i,2)}(1),...
        job{job_serial(i,1)}{job_serial(i,2)}(3),...
        job{job_serial(i,1)}{job_serial(i,2)}(4),...
        true);
    if insert_pot > 0
        if insert_pot == 1
            mac_serial{the_mac} = [job_serial(i,:); mac_serial{the_mac}];
        else
            mac_serial{the_mac} = [mac_serial{the_mac}(1:insert_pot-1,:);job_serial(i,:);mac_serial{the_mac}(insert_pot:end,:)];
        end
        job_end{job_serial(i,1)}(end+1)=job_end_time;
    else
        overtime(end+1,:) = job_serial(i,:);
        job_end{job_serial(i,1)}(end+1)=job_end_time;
    end

end

%�����������깤ʱ��
global MAX_END_TIME
max_mac_time=0;
if ~isempty(overtime)
    max_mac_time = MAX_END_TIME;
else
    for i=1:sum(mac_num)
        if ~isempty(mac_end{i})
            max_mac_time=max(max_mac_time,max(mac_end{i}));
        end
    end
end
end
