% Create structure of the results_maxima

% First start with the maxima data

% Initialize an empty struct array
runs = struct('run_number', {}, 'rho', {}, 'mu', {}, 'results_maxima', {});

% Initialize the index for storing runs
run_index = 1;

% Iterate through the matrix
i = 1;
while i <= size(results_maxima, 1)
    % Check if the row is a header (integer in the first column)
    if mod(results_maxima(i, 1), 1) == 0
        % Extract the header information
        run_number = results_maxima(i, 1);
        rho = results_maxima(i, 2);
        mu = results_maxima(i, 3);
        
        % Initialize an empty array for the results_maxima rows
        run_results_maxima = nan(1, 3);
        
        % Move to the next row
        i = i + 1;
        
        % Collect all subsequent rows that belong to this run
        while i <= size(results_maxima, 1) && mod(results_maxima(i, 1), 1) ~= 0
            run_results_maxima = [run_results_maxima; results_maxima(i, :)];
            i = i + 1;
        end
        
        % Store the information in the struct array
        runs(run_index).run_number = run_number;
        runs(run_index).rho = rho;
        runs(run_index).mu = mu;
        runs(run_index).results_maxima = run_results_maxima;
        
        % Increment the run index
        run_index = run_index + 1;
    end
end


%% Now I need to clean the positive maxima

% Loop through each run
for run_index = 1:length(runs)
    % Access the results_maxima for the current run
    run_results_maxima = runs(run_index).results_maxima;
    
    % Check the second column for negative values and delete corresponding rows
    % Keep only rows where the second column value is non-negative
    cleaned_results_maxima = run_results_maxima(run_results_maxima(:, 2) >= 0, :);
    
    % Update the results_maxima for the current run with the cleaned results_maxima
    runs(run_index).results_maxima = cleaned_results_maxima;
end

runs_max = runs;

%% Now the same for the minima


% Example of accessing the structured results_maxima
% disp(runs(1).rho)  % Access rho of the first run
% disp(runs(1).results_maxima) % Access results_maxima of the first run
