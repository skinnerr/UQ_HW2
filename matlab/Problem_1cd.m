function [] = Problem_1cd()

Set_Default_Plot_Properties();

% Number of samples.
N  = 10000;

% First r.v. with analytical inversion.
U  = rand(1,N);
X1 = -log(1-U);

% Second r.v. with numerical inversion.
U  = rand(1,N);
X2 = nan(1,N);
fun = @(x1,x2) 1 - (1+x2) .* exp(-x2-x1*x2);
x0 = [0, 100];
for i = 1:N
	X2(i) = fzero( @(x2) fun(X1(i),x2) - U(i), x0);
end

% Calculate and report averages.

n = 1:N;
avgs = nan(3,length(n));
for i = 1:length(n)
    a = X1(1:n(i));
    b = X2(1:n(i));
    avgs(1,i) = mean(a);
    avgs(2,i) = mean(b);
    avgs(3,i) = mean(a.*b);
end

fprintf('<x1> = %.3f\n<x2> = %.3f\n<x1.x2> = %.3f\n', avgs(1,i), avgs(2,i), avgs(3,i));

% Plotting routine.

figure();

subplot(2,1,1);
hold on;
plot(n,avgs');
plot(n,ones(1,length(n)),'--k');
plot(n,0.596*ones(1,length(n)),':k');
hleg = legend({'<x_1>','<x_2>','<x_1\cdotx_2>','1','0.596'});
set(hleg,'Location','northeast');
set(gca,'XScale','log');

subplot(2,1,2);
hold on;
truth = repmat([1,1,0.596347],N,1);
error = abs(avgs' - truth) ./ truth;
plot(n,error);
hleg = legend({'RelErr[<x_1>]','RelErr[<x_2>]','RelErr[<x_1\cdotx_2>]'});
set(hleg,'Location','southwest');
set(gca,'XScale','log');
set(gca,'YScale','log');
xlabel('Cumulative Samples');

end