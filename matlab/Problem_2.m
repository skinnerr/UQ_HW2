function [] = Problem_2()
    
    Set_Default_Plot_Properties();
    
    realizations = 10000;
    
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
    for i = 1:realizations
        u(i,:) = Solve_u(h, u0, uf(i), K(i,:));
    end
    
    % Plot realizations of G.
    figure();
    plot(x, G(1:10,:));
    
    % Plot realizations of K.
    figure();
    plot(x, K(1:10,:));
    
    % Plot realizations of u.
    figure();
    plot(x, u(1:10,:));
    
    % Plot statistics of u.
    figure();
%     n = [10, 30, 100, 300, 1000, 3000, 10000, 30000, 100000];
    n = [10, 30, 100, 300, 1000, 3000, 10000];
%     n = [10, 30, 100, 300, 1000];
%     n = [10, 30];
    for i = n
        if i == n(end)
            size = 3;
        else
            size = 1.5;
        end
        subplot(2,1,1);
        hold on;
        plot(x, mean(u(1:i,:)), 'DisplayName', sprintf('n = %i', i), 'LineWidth', size);
        subplot(2,1,2);
        hold on;
        plot(x,  var(u(1:i,:)), 'Displayname', sprintf('n = %i', i), 'LineWidth', size);
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
    n = 1:realizations;
    prob = nan(1,length(n));
    for i = 1:length(n)
        umax = max(u(1:n(i),:),[],2);
        m = mean(umax);
        v = var(umax);
        hits = sum( umax > ( m + 3*sqrt(v) ) );
        prob(i) = hits / n(i);
    end
    figure();
    hold on;
    plot(n, prob);
    plot([1,realizations], prob(end)*[1,1], '--');
    xlabel('Cumulative Realizations');
    ylabel('Probability');
    fprintf('Probability of excessive temperature: %.4e\n', prob(end));
    fprintf('  E(umax) = %.4e\n', m);
    fprintf('Var(umax) = %.4e\n', v);
    
end










