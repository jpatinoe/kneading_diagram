%% Load data structure

load('/Users/jpat943/Documents/2024/TIDES/Kneading Diagram/Merged Data/merged_runs.mat')

%% Create kneading structure

% Initialize the new symbolic structure
symbolic_runs = struct('run_number', {}, 'rho', {}, 'mu', {}, 'symbolic_data', {});

% Loop through each run in merged_runs
for run_index = 1:length(merged_runs)
    % Extract the current run's data, rho, and mu
    current_data = merged_runs(run_index).data;
    rho = merged_runs(run_index).rho;
    mu = merged_runs(run_index).mu;
    
    % Initialize the symbolic data array
    symbolic_data = [];
    
    % Check if the current_data is empty
    if isempty(current_data)
        % If empty, assign +1 to the symbolic_data
        symbolic_data = 1;
    else
        % Loop through each row in current_data
        for row_index = 1:size(current_data, 1)
            % Check the second column of the current row
            if current_data(row_index, 2) > 0
                symbolic_value = 1;  % Positive value, assign +1
            elseif current_data(row_index, 2) < 0
                symbolic_value = -1; % Negative value, assign -1
            else
                symbolic_value = 1;  % Zero or empty, assign +1
            end
            % Append the symbolic_value to the symbolic_data array
            symbolic_data = [symbolic_data; symbolic_value];
        end
    end
    
    % Store the results in the symbolic_runs structure
    symbolic_runs(run_index).run_number = merged_runs(run_index).run_number;
    symbolic_runs(run_index).rho = rho;
    symbolic_runs(run_index).mu = mu;
    symbolic_runs(run_index).symbolic_data = symbolic_data;
end

%% Create Symbolic Kneading Matrix

%Create a matrix with 12 symbols
Kneading_sequence_matrix = nan(length(merged_runs),12);

% Loop through each run in symbolic_runs
for run_index = 1:length(symbolic_runs)
    % Get the symbolic data for the current run
    symbolic_data = symbolic_runs(run_index).symbolic_data;
    
    % Determine the number of entries to copy (up to a maximum of 12)
    num_entries = min(length(symbolic_data), 12);
    
    % Fill the corresponding row in Kneading_sequence_matrix
    Kneading_sequence_matrix(run_index, 1:num_entries) = symbolic_data(1:num_entries);
end

% Complete the nan spaces. This are generated when we reach a steady state
% for example and we are not longer oscillating

% Loop through each row in Kneading_sequence_matrix
for row_index = 1:size(Kneading_sequence_matrix, 1)
    % Get the current row
    current_row = Kneading_sequence_matrix(row_index, :);
    
    % Find the first NaN entry in the row
    first_nan_index = find(isnan(current_row), 1);
    
    % If there is a NaN in the row, apply the replacement rule
    if ~isempty(first_nan_index)
        % Check the entry to the left of the first NaN
        if first_nan_index > 1
            left_value = current_row(first_nan_index - 1);
        else
            % If the NaN is at the first position, assume a default value
            left_value = 1; % Default to 1 if there's no value to the left
        end
        
        % Determine the replacement value based on the left_value
        if left_value > 0
            replacement_value = 1;
        else
            replacement_value = -1;
        end
        
        % Replace NaN values with the determined replacement_value
        current_row(isnan(current_row)) = replacement_value;
    end
    
    % Update the row in the matrix
    Kneading_sequence_matrix(row_index, :) = current_row;
end

%% Create kneading_matrix

events = 12;
% create q vector
q = 0.5; %this should be a number between 0 and 1
q_vector = q.^(1:events);

kneading_matrix = zeros(length(merged_runs),events);
for row = 1:length(merged_runs)
    for column = 1:events
    kneading_matrix(row,column) = dot(Kneading_sequence_matrix(row,1:column),q_vector(1:column));
    end
end

%% Save Kneading Invariant structure for plotting later

% Initialize the kneading_invariant structure
kneading_invariant = struct('run_number', {}, 'rho', {}, 'mu', {}, 'data', {});

% Loop through each run in the symbolic_runs structure
for run_index = 1:length(symbolic_runs)
    % Get the corresponding rho, mu, and data values
    run_number = symbolic_runs(run_index).run_number;
    rho = symbolic_runs(run_index).rho;
    mu = symbolic_runs(run_index).mu;
    kneading_data = kneading_matrix(run_index, :);
    
    % Store the values in the kneading_invariant structure
    kneading_invariant(run_index).run_number = run_number;
    kneading_invariant(run_index).rho = rho;
    kneading_invariant(run_index).mu = mu;
    kneading_invariant(run_index).data = kneading_data;
end

%%
save('kneading_invariant.mat', 'kneading_invariant');

% clearvars -except kneading_invariant
