% 狼群算法
%fitness_func - 适应度函数
%lb = -10;
%ub = 10;
%dim = 2;
%max_gen = 10;
%pop_size = 5;
%alpha = 0.5;
%beta = 0.5;
%delta = 0.5;
function [bestX, bestF] = wolf_pack_algorithm(lb, ub, dim, max_gen, pop_size, alpha, beta, delta)
% fitness_func - 适应度函数
% lb - 自变量下界
% ub - 自变量上界
% dim - 自变量维度
% max_gen - 最大迭代次数
% pop_size - 种群大小
% alpha - 狼群更新常数
% beta - 狼群更新常数
% delta - 狼群更新常数
    % 初始化种群
    pop = create_population(lb, ub, dim, pop_size);
    % 计算适应度
    fitness = evaluate_fitness( pop, pop_size);
    % 寻找最优解
    [bestF, bestIdx] = min(fitness);
    bestX = pop(bestIdx, :);
    % 迭代优化
    for gen = 1:max_gen
        % 更新狼群位置
        for i = 1:pop_size
            % 计算狼群中每个狼的适应度
            fitness_i = fitness(i);
            for j = 1:pop_size
                if fitness(j) < fitness_i
                    r1 = rand(1, dim);
                    r2 = rand(1, dim);
                    A = alpha * (2 * r1 - 1);
                    C = 2 * r2;
                    D = abs(C .* bestX - pop(i, :));
                    X1 = bestX - A .* D;
                    fitness_X1 = evaluate_fitness( X1, 1);
                    % 更新最优解
                    if fitness_X1 < bestF
                        bestF = fitness_X1;
                        bestX = X1;
                    end
                    % 更新狼群位置
                    if fitness_X1 < fitness_i
                        pop(i, :) = X1;
                        fitness_i = fitness_X1;
                    else
                        r3 = rand;
                        if r3 < beta
                            X2 = pop(j, :) + delta * (rand(1, dim) - 0.5);
                            fitness_X2 = evaluate_fitness( X2, 1);
                            % 更新最优解
                            if fitness_X2 < bestF
                                bestF = fitness_X2;
                                bestX = X2;
                            end
                            % 更新狼群位置
                            if fitness_X2 < fitness_i
                                pop(i, :) = X2;
                                fitness_i = fitness_X2;
                            end
                        end
                    end
                end
            end
        end
    end
end
% 初始化种群
function pop = create_population(lb, ub, dim, pop_size)
    pop = repmat(lb, pop_size, 1) + rand(pop_size, dim) .* repmat((ub - lb), pop_size, 1);
end
% 计算适应度
function fitness = evaluate_fitness( pop, pop_size)
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        fitness(i) = norm(pop(i, :));
        %distance(i)=norm(pop(i,:));

    end
end