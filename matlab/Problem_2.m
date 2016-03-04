function [] = Problem_2()
    
    Set_Default_Plot_Properties();
    
    realizations = 100000;
    
    %%%
    % Define variables specific to the boundary-value problem.
    %%%
    
    % Solution domain.
    N = 101;
    x0 = 0;
    xf = 1;
    x = linspace(x0, xf, N)';
    h = x(2) - x(1);
    
    % Boundary conditions (0 = initial, f = final).
    u0  = 0;
    uf  = randn(1, realizations) * sqrt(0.1); % Random variable theta ~ N(0, 0.1)
    
    % Generate K
    G = Generate_G(N, realizations);
    K = exp(G);

    % Solve for u
    u = nan(realizations, N);
    for numb = 1:realizations
        u(numb,:) = Solve_u(h, u0, uf(numb), K(numb,:));
    end
    
    % Plot realizations of G.
    figure();
    subplot(3,1,1);
    plot(x, G(1:10,:));
    ylabel('G(x,\omega)');
    xlabel('x');
    % Plot realizations of K.
    subplot(3,1,2);
    plot(x, K(1:10,:));
    ylabel('K(x,\omega)');
    xlabel('x');
    % Plot realizations of u.
    subplot(3,1,3);
    plot(x, u(1:10,:));
    ylabel('u');
    xlabel('x');
    
    % Plot statistics of u.
    figure();
    n = [100, 300, 1000, 3000, 10000, 30000, 100000];
%     n = [10, 30, 100, 300, 1000, 3000, 10000];
%     n = [10, 30, 100, 300, 1000];
%     n = [10, 30];
    rgb = flip(copper(length(n)));
    index = 0;
    for numb = n
        index = index + 1;
        if index == length(n)
            size = 3;
        else
            size = 1.5;
        end
        subplot(2,1,1);
        hold on;
        plot(x, mean(u(1:numb,:)), 'DisplayName', sprintf('n = %i', numb), ...
                                   'LineWidth', size, 'Color', rgb(index,:));
        subplot(2,1,2);
        hold on;
        plot(x,  var(u(1:numb,:)), 'Displayname', sprintf('n = %i', numb), ...
                                   'LineWidth', size, 'Color', rgb(index,:));
    end
    subplot(2,1,1);
    xlabel('x');
    ylabel('Mean');
    hleg1 = legend('show');
    set(hleg1, 'Location', 'eastoutside');
    subplot(2,1,2);
    xlabel('x');
    ylabel('Variance');
    hleg2 = legend('show');
    set(hleg2, 'Location', 'eastoutside');
    
    % Calculate probability of excessive max temperature.
    n = 100:10000;
    prob = nan(1,length(n));
    for numb = 1:length(n)
        umax = max(u(1:n(numb),:),[],2);
        m = mean(umax);
        v = var(umax);
        hits = sum( umax > ( m + 3*sqrt(v) ) );
        prob(numb) = hits / n(numb);
    end
    figure();
    hold on;
    plot(n, prob);
    plot([n(1),n(end)], prob(end)*[1,1], '--');
    set(gca, 'XScale', 'log');
    xlabel('Cumulative Realizations');
    ylabel('Probability');
    
    umax = max(u,[],2);
    m = mean(umax);
    v = var(umax);
    hits = sum( umax > ( m + 3*sqrt(v) ) );
    prob = hits / realizations;
    fprintf('  E(umax) = %.4e\n', m);
    fprintf('Var(umax) = %.4e\n', v);
    fprintf('Probability of excessive temperature: %.4e\n', prob);
    
end










