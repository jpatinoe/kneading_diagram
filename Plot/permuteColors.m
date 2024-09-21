function [colorCodes] = permuteColors_new(c_And,level)
% Generate the sequence to rearrange the rows

sequence = generate_sequence(level);  % Get the rearrangement sequence
order = 1:2^level;
aux = zeros(2^level,2);
aux(:,1) = order;
aux(:,2) = sequence;

sorted_aux = sortrows(aux, 2);
colorCodes = c_And(sorted_aux(:,1), :);

end
