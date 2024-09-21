%% Load Data
load('/Users/jpat943/Documents/2024/TIDES/Kneading Diagram/Create Kneading Sequence/kneading_invariant.mat')
%% Plotting Parameters
point_size = 100;
line_size = 3.5;
label_size = 24;
box_linewidth = 1.7;
mainColor = [255, 165, 0] / 255; % #F57C00 in RGB
darkGray = '#bfbfbf';

%% Create Figure and Axis
fig = figure('Units', 'points', 'Position', [0, 0, 1200, 480], 'PaperUnits', 'points', 'PaperSize', [1200, 480]);
ax = axes(fig, 'Units', 'normalized', 'Position', [0.05, 0.06, 0.9, 0.9]);
hold on;

%% Kneading diagram
%first create the colors
level = 2; % Levels to plot
c_And      = distinguishable_colors(2^(level));
c_And      = permuteColors(c_And,level);

colormap(c_And);

%% Kneading diagram plot 
rho = zeros(length(kneading_invariant), 1);
mu = zeros(length(kneading_invariant), 1);
color_data = zeros(length(kneading_invariant), 1);
% Loop through each run in kneading_invariant
for run_index = 1:length(kneading_invariant)
    % Extract the first value from the first column of data
    rho(run_index) = kneading_invariant(run_index).rho;
    mu(run_index) = kneading_invariant(run_index).mu;
    color_data(run_index) = kneading_invariant(run_index).data(level+1);
end

scatter(rho,mu,14,color_data,'filled','s')

%% Plot Adjustments

pbaspect([1 1 1]);
axis([12 96 0 6.2])
box on;
set(gca, 'LineWidth', box_linewidth);
set(gca, 'Layer', 'top');
set(gca, 'Color', 'none');
set(ax, 'FontSize', label_size, 'TickLabelInterpreter', 'latex');
tightfig(fig);
hold off;

%% Save Figure
%print(fig, 'test', '-dpng', '-r300');
