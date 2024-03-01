clear;

% 初始化图形窗口
figure;
hold on;
grid on;
% grid minor;
axis equal;
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
xlim([-10, 10]);
ylim([-10, 10]);
zlim([-10, 10]);

% view(3); % 设置三维视图
% view([-72.5 1.1]);
view([14.9 3.5]);
view([17.4 5.9]);

% set(gca,'xtick', [],'xticklabel', []);
set(gca,'xticklabel', []);
set(gca,'yticklabel', []);
set(gca,'zticklabel', []);

% 添加X, Y, Z坐标轴
% 定义坐标轴的长度
axis_length = 10;

% 绘制X轴
plot3([-axis_length, axis_length], [0, 0], [0, 0], ...
    '--', 'Color', 'black', 'LineWidth', 1);
text(axis_length, 0, 0, 'X', 'FontSize', 10, 'Color', 'black');

% 绘制Y轴
plot3([0, 0], [-axis_length, axis_length], [0, 0], ...
    '--', 'Color', 'black', 'LineWidth', 1);
text(0, axis_length, 0, 'Y', 'FontSize', 10, 'Color', 'black');

% 绘制Z轴
plot3([0, 0], [0, 0], [-axis_length, axis_length], ...
    '--', 'Color', 'black', 'LineWidth', 1);
text(0, 0, axis_length, 'Z', 'FontSize', 10, 'Color', 'black');

% 八个卦限的起点坐标
start_points = [
    10, 10, 10;   % 第一卦限
    -10, 10, 10;  % 第二卦限
    -10, -10, 10; % 第三卦限
    10, -10, 10;  % 第四卦限
    10, 10, -10;  % 第五卦限
    -10, 10, -10; % 第六卦限
    -10, -10, -10;% 第七卦限
    10, -10, -10; % 第八卦限
];

% 遍历每个起点绘制直线和箭头
for i = 1:size(start_points, 1)
    start_point = start_points(i, :)*0.4;
    % 绘制从起点到原点的直线
    plot3([start_point(1), 0], [start_point(2), 0], [start_point(3), 0], ...
        'k', 'LineWidth', 1.2);
    
    % 计算并绘制箭头
    % 箭头的起点是直线的中点
    mid_point = start_points(i, :) *0.8;
    % 箭头的方向向量（指向原点）
    direction = -start_points(i, :) *0.4;
    % 箭头的长度应该与方向向量的长度一致，但这里可以根据需要进行调整
    % 确保箭头大小适中，不至于覆盖过多的直线部分
    % arrow_length = sqrt(sum(mid_point.^2));
    quiver3(mid_point(1), mid_point(2), mid_point(3), ...
        direction(1), direction(2), direction(3), ...
        'AutoScale', 'off', ...
        'MaxHeadSize', 1, ...
        'LineWidth', 1.2, ...
        'Color', 'black');
end

hold off;
