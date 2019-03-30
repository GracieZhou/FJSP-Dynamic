%输入机器开始时间，结束时间，最大完工时间
%画出一个甘特图
function draw_gantt(max_mac_time, mac_serial, mac_start, mac_end, job, mac, time)
global MIN_START_TIME

% 获取mac的个数
nb_mac = mac_max_num(mac);

% 获取job个数
job_num = length(job);

color=rand(job_num,3); %生成随机的颜色,并使其方差和大于0.3，防止出现多个相似颜色
while  min(mean(color,2)) < 0.2 %sum(var(color)) < 0.3
    color = rand(job_num,3);
end
figure;
if time > MIN_START_TIME
    plot([time,time], [0 nb_mac], 'r--');
    hold on;
end

axis([MIN_START_TIME, max_mac_time+1, 0, nb_mac+0.5]);%x轴 y轴的范围
set(gca,'xtick',MIN_START_TIME:1:max_mac_time+1) ;%x轴的增长幅度
set(gca,'ytick',0:1:nb_mac+0.5) ;%y轴的增长幅度
xlabel('处理时长','FontName','微软雅黑','Color','b','FontSize',10)
ylabel('医疗资源','FontName','微软雅黑','Color','b','FontSize',10,'Rotation',90)
title('解码甘特图','fontname','微软雅黑','Color','b','FontSize',16);%图形的标题


for i=1:nb_mac
    for j=1:length(mac_start{i})
        timelast = mac_end{i}(j)-mac_start{i}(j);
        if timelast <= 0
            continue;
        end
        
        rec=[mac_start{i}(j),i-0.3,timelast,0.6];%设置矩形的位置，[矩形左下顶点的x坐标，y坐标，长度，高度]
        txt=sprintf('p(%d,%d)=%3.1f',mac_serial{i}(j,1),mac_serial{i}(j,2),timelast);%将工序号，加工时间连城字符串
        rectangle('Position',rec,'LineWidth',0.5,'LineStyle','-','FaceColor',color(mac_serial{i}(j,1),:));%画每个矩形  
        text(mac_start{i}(j)+0.2,i,txt,'FontWeight','Bold','FontSize',10);%在矩形上标注工序号，加工时间
    end
end
end