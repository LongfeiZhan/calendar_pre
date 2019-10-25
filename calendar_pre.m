clear;
clc;

% pre = xlsread('D:\BRICKS\MCI指数计算\data.xls','SURF_JX_PRE_DAY');
% ys_nc(:,1) = pre(:,1);
% ys_nc(:,2) = pre(:,58);%---玉山站---
% ys_nc(:,3) = pre(:,42);%---南昌站---
% tic
% %% 降水日数计算
% load('ys_nc.mat');%---第一列玉山，第二列南昌---
% count = zeros(365,4);
% for i = 1 : 365
%     i
%     for j = 1 : length(ys_nc)
%         str1 = num2str(ys_nc(i,1));
%         str2 = num2str(ys_nc(j,1));
%         if strcmp(str1(5:8),str2(5:8))
%             count(i,1) = str2num(str1(5:8));
%             count(i,2) = count(i,2) + 1;
%             if ys_nc(j,2) > 0
%                 count(i,3) = count(i,3) + 1;
%             end
%             if ys_nc(j,3) > 0
%                 count(i,4) = count(i,4) + 1;
%             end
%         end
%     end
% end
% toc
load('count.mat')
count(:,5) = count(:,3)./count(:,2);
%% 按照日历排序

col = 1;row = 1;
for i = 1 : 365
    if i < 365
        if floor(count(i,1)/100) == floor(count(i+1,1)/100)
            mon = floor(count(i,1)/100);
            eval(['pre',num2str(mon),'(row,col)','=', 'count(i,5);']);
            col = col + 1;
            if col == 8
                row = row + 1;
                col = 1;
            end
        else
            eval(['pre',num2str(mon),'(row,col)','=', 'count(i,5);']);
            row = 1;
            col = 1;
        end
    else
        pre12(row,col) = count(i,5);
    end
end
pre2(5,1:7) = 0;
%% 开始绘制格子图
for i = 1 : 12
    subplot(4,3,i)
    x = 1 : 8;
    y = 1 : 6;
    %% 两根线的数据
    x1 = [x(1) x(end)]';
    y1 = [y(1) y(end)]';
    %% 所有线的xData
    x2 = repmat(x1, 1, length(y)-2);
    x3 = repmat(x(2) : x(end-1), 2, 1);
    xData = [x2 x3];
    %% 所有线的yData
    y2 = repmat(y1, 1, length(x)-2);
    y3 = repmat(y(2) : y(end-1), 2, 1);
    yData = [y3 y2];
    %% 绘图
    h = line(xData, yData);
    box on;
    set(h, 'Color', 'k');
    %% 第(i, j)个网格为红色
    
    for r = 1 : 5
%         if r == 5 & i == 2
%             break
%         end
        for c = 1 : 7
            value = eval(['pre',num2str(i),'(',num2str(r),',',num2str(c),')',';']);
            pi = c;
            pj = -r;
            x = [1 2 2 1] + pi - 1;
            y = [5 5 6 6] + pj + 1;
            
            if value < 0.2 & value > 0
               h1 = patch('xData', x, 'yData', y, 'FaceColor', [0 255 127]/255);
            elseif value >= 0.2 & value < 0.3
               h2 = patch('xData', x, 'yData', y, 'FaceColor', [0 139 0]/255);
            elseif value >= 0.3 & value < 0.4
               h3 = patch('xData', x, 'yData', y, 'FaceColor', [135 206 255]/255);
            elseif value >= 0.4 & value < 0.5
               h4 = patch('xData', x, 'yData', y, 'FaceColor', [65 105 225]/255);
            elseif value >= 0.5 & value < 0.6
                h5 = patch('xData', x, 'yData', y, 'FaceColor', [199 21 133]/255);
            elseif value >= 0.6 & value < 0.7
                h6 = patch('xData', x, 'yData', y, 'FaceColor', [238 118 0]/255);
            elseif value >= 0.7
                h7 = patch('xData', x, 'yData', y, 'FaceColor', [139 37 0]/255);
            else
                patch('xData', x, 'yData', y, 'FaceColor', [181 181 181]/255);
            end
        end
    end
    xlim([1,8]);ylim([1,6])
    title([num2str(i),'月'])
    for dd = 1 : 7
        text(1.4+dd-1,5.5,[num2str(dd)])
    end
    for dd = 8 : 9
        text(1.4+dd-8,4.5,[num2str(dd)])
    end
    for dd = 10 : 14
        text(1.3+dd-8,4.5,[num2str(dd)])
    end
    for dd = 15 : 21
        text(1.3+dd-15,3.5,[num2str(dd)])
    end
    for dd = 22 : 28
        text(1.3+dd-22,2.5,[num2str(dd)])
    end
    if i == 1 | i == 3 | i == 5 | i == 7 | i == 8 | i == 10 | i == 12
        for dd = 29 : 31
            text(1.3+dd-29,1.5,[num2str(dd)])
        end
    elseif i == 4 | i == 6 | i == 9 | i == 11
        for dd = 29 : 30
            text(1.3+dd-29,1.5,[num2str(dd)])
        end
    end
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
end

lgd = legend([h1,h2,h3,h4,h5,h6,h7],'0~20%','20~30%','30~40%','40~50%',...
    '50~60%','60~70%','70~80%','Orientation','horizontal');
title(lgd,'玉山降水概率','FontSize',12)





