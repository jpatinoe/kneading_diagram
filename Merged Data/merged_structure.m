% Initialize a new struct array to hold the merged and sorted data
merged_runs = struct('run_number', {}, 'rho', {}, 'mu', {}, 'data', {});

% Loop through each run, assuming both runs_max and runs_min have the same number of runs
for run_index = 1:length(runs_max)
    % Merge the data from runs1 and runs2 for the current run
    merged_data = [runs_max(run_index).results_maxima; runs_min(run_index).results_minima];
    
    % Sort the merged data by the first column
    sorted_data = sortrows(merged_data, 1);
    
    % Store the sorted data in the new struct
    merged_runs(run_index).run_number = runs_max(run_index).run_number;
    merged_runs(run_index).rho = runs_max(run_index).rho;  % Assuming rho and mu are the same in both structures
    merged_runs(run_index).mu = runs_max(run_index).mu;
    merged_runs(run_index).data = sorted_data;
end

% % Example: Display the merged and sorted data for each run
% for run_index = 1:length(merged_runs)
%     fprintf('Run %d, rho = %.2f, mu = %.2f:\n', ...
%         merged_runs(run_index).run_number, merged_runs(run_index).rho, merged_runs(run_index).mu);
%     disp(merged_runs(run_index).data);
% end

%% Save Final Structure

% Save the merged_runs structure to a .mat file
save('merged_runs.mat', 'merged_runs');
