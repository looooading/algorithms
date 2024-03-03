function [informap] = A_star(maps, step_size)
    % A_star algorithm for path planning
    % maps: map of the environment, 0 represents obstacles, other values represent free space
    % step_size: step size for the algorithm

    % Get the size of the map
    [height, width] = size(maps);

    % Initialize the start and end points
    star = {'位置': (50, 50), '代价': 0, '父节点': (50, 50)};
    end = {'位置': (400, 400), '代价': 0, '父节点': (400, 400)};

    % Initialize the open and close lists
    openlist = [];
    closelist = [star];

    while 1
        % Get the current point
        s_point = closelist(end)['位置'];

        % Calculate the possible movements
        add = [0, step_size; 0, -step_size; step_size, 0; -step_size, 0];

        for i = 1:size(add, 1)
            x = s_point(1) + add(i, 1);
            if x < 1 || x > width
                continue;
            end
            y = s_point(2) + add(i, 2);
            if y < 1 || y > height
                continue;
            end
            G = norm(x - star['位置'](1)) + norm(y - star['位置'](2));
            H = norm(x - end['位置'](1)) + norm(y - end['位置'](2));
            F = G + H;
            if H < 20
                step_size = 1;
            end
            addpoint = {'位置': [x, y], '代价': F, '父节点': s_point};
            count = 0;
            for j = 1:length(openlist)
                if openlist(j)['位置'] == addpoint['位置']
                    count = count + 1;
                end
            end
            for j = 1:length(closelist)
                if closelist(j)['位置'] == addpoint['位置']
                    count = count + 1;
                end
            end
            if count == 0
                if maps(y, x) != 0
                    openlist = [openlist; addpoint];
                end
            end
        end

        % Find the point with the minimum cost in the open list
        t_point = {'位置': (50, 50), '代价': 10000, '父节点': (50, 50)};
        for j = 1:length(openlist)
            if openlist(j)['代价'] < t_point['代价']
                t_point = openlist(j);
            end
        end

        % Remove the point from the open list and add it to the close list
        for j = 1:length(openlist)
            if t_point == openlist(j)
                openlist(j) = [];
                break;
            end
        end
        closelist = [closelist; t_point];

        % Check if the end point is reached
        if t_point['位置'] == end['位置']
            disp('找到终点');
            break;
        end
    end

    % Find the path by backtracking from the end point
    road = [];
    road(end) = closelist(end);
    point = road(end);
    k = 0;

    while 1
        for i = 1:length(closelist)
            if closelist(i)['位置'] == point['父节点']
                point = closelist(i);
                road(k + 1) = point;
                k = k + 1;
            end
        end
        if point == star
            disp('路径搜索完成');
            break;
        end
    end

    % Draw the planned path on the map
    informap = maps;
    for i = 1:length(road)
        informap(road(i)['位置']) = [0, 0, 200];
    end
    informap(star['位置']) = [0, 255, 0];
    informap(end['位置']) = [0, 255, 100];
    imshow(informap);
    save('informap.png', informap);
end