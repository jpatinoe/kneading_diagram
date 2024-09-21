% Create structure of the results_minima

% First start with the maxima data

% Initialize an empty struct array
runs = struct('run_number', {}, 'rho', {}, 'mu', {}, 'results_minima', {});

% Initialize the index for storing runs
run_index = 1;

% Iterate through the matrix
i = 1;
while i <= size(results_minima, 1)
    % Check if the row is a header (integer in the first column)
    if mod(results_minima(i, 1), 1) == 0
        % Extract the header information
        run_number = results_minima(i, 1);
        rho = results_minima(i, 2);
        mu = results_minima(i, 3);
        
        % Initialize an empty array for the results_minima rows
        run_results_minima = nan(1, 3);
        
        % Move to the next row
        i = i + 1;
        
        % Collect all subsequent rows that belong to this run
        while i <= size(results_minima, 1) && mod(results_minima(i, 1), 1) ~= 0
            run_results_minima = [run_results_minima; results_minima(i, :)];
            i = i + 1;
        end
        
        % Store the information in the struct array
        runs(run_index).run_number = run_number;
        runs(run_index).rho = rho;
        runs(run_index).mu = mu;
        runs(run_index).results_minima = run_results_minima;
        
        % Increment the run index
        run_index = run_index + 1;
    end
end


%% Now I need to clean the positive maxima

% Loop through each run
for run_index = 1:length(runs)
    % Access the results_minima for the current run
    run_results_minima = runs(run_index).results_minima;
    
    % Check the second column for negative values and delete corresponding rows
    % Keep only rows where the second column value is non-negative
    cleaned_results_minima = run_results_minima(run_results_minima(:, 2) <= 0, :);
    
    % Update the results_minima for the current run with the cleaned results_minima
    runs(run_index).results_minima = cleaned_results_minima;
end

runs_min = runs;
%% Now the same for the minima


% Example of accessing the structured results_minima
% disp(runs(1).rho)  % Access rho of the first run
% disp(runs(1).results_minima) % Access results_minima of the first run
