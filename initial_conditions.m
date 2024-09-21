%% Create data for parameters and initial condition to integrate

% Define the range of rho and mu values
aspect_ratio = 2.5; %This means x = 2.5*y
delta_x = 0.1;
delta_y = delta_x/aspect_ratio;
rho_values = 11.9:delta_x:96.0;
mu_values = 0.0:delta_y:7.0;

% Calculate the total number of entries
num_rho = length(rho_values);
num_mu = length(mu_values);
total_entries = num_rho * num_mu;

% Preallocate the results matrix
% The size of each row is 1 (rho) + 1 (mu) + 4 (elements of vector v) = 6 columns
results = zeros(total_entries, 6);

% Initialize an index for filling the results matrix
index = 1;

for i = 1:num_rho
    for j = 1:num_mu
        rho = rho_values(i);
        mu = mu_values(j);

        % Initialize the 2D vector vaux
        vaux = zeros(1, 2);

        % Calculate the components of the unstable eigenvector
        vaux(1) = -(9 - sqrt(81 + 40*rho))/(2*rho);
        vaux(2) = 1.0;

        % Normalize the vector
        norm_vaux = sqrt(vaux(1)^2 + vaux(2)^2);

        % Create the 4D vector v
        v = [0.001 * (vaux(1) / norm_vaux), 0.001 * (vaux(2) / norm_vaux), 0.0, 0.0];

        % Store the result in the preallocated matrix
        results(index, :) = [rho, mu, v];
        
        % Increment the index
        index = index + 1;
    end
end

%% Save the results
% Write to a text file
% Define the filename for the output
filename = 'params_initial_conditions.txt';

% Write the matrix to a text file
writematrix(results, filename, 'Delimiter', ' ');
