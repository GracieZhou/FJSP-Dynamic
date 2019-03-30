%���������ʼʱ�䣬����ʱ�䣬����깤ʱ��
%����һ������ͼ
function draw_gantt(max_mac_time, mac_serial, mac_start, mac_end, job, mac, time)
global MIN_START_TIME

% ��ȡmac�ĸ���
nb_mac = mac_max_num(mac);

% ��ȡjob����
job_num = length(job);

color=rand(job_num,3); %�����������ɫ,��ʹ�䷽��ʹ���0.3����ֹ���ֶ��������ɫ
while  min(mean(color,2)) < 0.2 %sum(var(color)) < 0.3
    color = rand(job_num,3);
end
figure;
if time > MIN_START_TIME
    plot([time,time], [0 nb_mac], 'r--');
    hold on;
end

axis([MIN_START_TIME, max_mac_time+1, 0, nb_mac+0.5]);%x�� y��ķ�Χ
set(gca,'xtick',MIN_START_TIME:1:max_mac_time+1) ;%x�����������
set(gca,'ytick',0:1:nb_mac+0.5) ;%y�����������
xlabel('����ʱ��','FontName','΢���ź�','Color','b','FontSize',10)
ylabel('ҽ����Դ','FontName','΢���ź�','Color','b','FontSize',10,'Rotation',90)
title('�������ͼ','fontname','΢���ź�','Color','b','FontSize',16);%ͼ�εı���


for i=1:nb_mac
    for j=1:length(mac_start{i})
        timelast = mac_end{i}(j)-mac_start{i}(j);
        if timelast <= 0
            continue;
        end
        
        rec=[mac_start{i}(j),i-0.3,timelast,0.6];%���þ��ε�λ�ã�[�������¶����x���꣬y���꣬���ȣ��߶�]
        txt=sprintf('p(%d,%d)=%3.1f',mac_serial{i}(j,1),mac_serial{i}(j,2),timelast);%������ţ��ӹ�ʱ�������ַ���
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(mac_serial{i}(j,1),:));%��ÿ������  
        text(mac_start{i}(j)+0.2,i,txt,'FontWeight','Bold','FontSize',10);%�ھ����ϱ�ע����ţ��ӹ�ʱ��
    end
end
end