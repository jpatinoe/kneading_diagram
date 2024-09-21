#!/bin/zsh

echo "Starting script execution..."

# Define file paths
input_file="params_initial_conditions.txt"
results_file="results_maxima.dat"

echo "Input file: $input_file"
echo "Output file: $results_file"

# Clear the output file using truncate
if [ -f "$results_file" ]; then
    echo "Clearing the output file: $results_file"
    truncate -s 0 "$results_file"
else
    echo "Output file does not exist. Creating a new one: $results_file"
    touch "$results_file"
fi

echo "Output file has been cleared or created."

line_number=1
while IFS= read -r line; do
    echo "Processing line $line_number: $line"

    # Extract parameters and initial conditions from the line
    p0=$(echo $line | awk '{print $1}')
    p1=$(echo $line | awk '{print $2}')
    v0=$(echo $line | awk '{print $3}')
    v1=$(echo $line | awk '{print $4}')
    v2=$(echo $line | awk '{print $5}')
    v3=$(echo $line | awk '{print $6}')

    # Write the parameters to the results file
    echo "$line_number   $p0   $p1 " >> "$results_file"

    # Run the C program
    ./LL_knead $p0 $p1 $v0 $v1 $v2 $v3

    # Append the contents of LL_knead_max.dat to the results file
    cat "LL_knead_max.dat" >> "$results_file"

    # Increment the line number for the next run
    line_number=$((line_number + 1))
done < "$input_file"

echo "Finished processing all lines."
echo "Script completed."
