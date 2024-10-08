---
# Project: Kneading diagram of the unstable manifold of the origin in a 4D Lorenz-like system

This repository contains the necessary files and steps to compute the kneading diagram of the unstable manifold of the origin in the 4D Lorenz-like system mentiond in [Gonchenko](https://iopscience.iop.org/article/10.1088/1361-6544/abc794). To compute it, we calculate local maxima and minima of $x$ in the trajectory generated by the unstable manifold of the origin for different parameter values; see [Barrio](https://arxiv.org/abs/1204.3278), [Giraldo](https://www.aimsciences.org/article/doi/10.3934/dcdsb.2021217), [Bitta](https://journals.aps.org/pre/abstract/10.1103/PhysRevE.108.064204) for references in the method. We compute the different trajectories with **TIDES**; see [Tides](https://cody.unizar.es/code/tides/) for information in how to install the package.

We use a mix of Mathematica, Fortran, C, to compute the trajectories, and then use Matlab for a final post-process of the data.

## Steps to Run the Project
### 1. Execution of TIDES and Modification of the Initial Driver

- First we need to create the driver that solves the system of ODEs. We do this in the same way as explain in [Tides](https://cody.unizar.es/code/tides/). Here, we use the options to compute events, which in this case corresponds to finding maxima and minima of the times series of the variable $x$. We do this separately since it is necessary to distinguish them to later assign the corresponding symbol in the sequence.

- After creating a driver to solve the differential equation we modify the file dr.LL_knead.c since this file solves for just one instance the system of ODEs for a unique initial condition and a particular parameter point. The file dr.LL_knead copy.c contains all the necessary changes to compute the trajectory for different initial conditions and different parameter values. The different initial conditions and parameter values are read from the file params_initial_conditions.txt. After modifying the driver code, you need compile and run the program in the terminal as follows:

$ gcc dr_LL_knead.c LL_knead.c -lTIDES -lm -o LL_knead

This will create the executable file that computes the different trajectories.

### 2. Define Parameters and Initial Conditions
- Create the parameter range and the corresponding initial conditions. These initial conditions are chosen to be on the linear approximation of the unstable manifold of the origin, which in this case can be calculated analytically.
- Run the MATLAB script `initial_conditions.m' in the main folder to generate the initial conditions. Modify the $\rho$ and $\mu$ ranges as needed.
  
### 2. Prepare for Maxima and Minima Calculations
- Copy the output file `params_initial_conditions.txt' from the MATLAB output to the **Find Maxima** and **Find Minima** folders.

### 3. Calculate Positive Maxima
- In the terminal, navigate to the **Find Maxima** folder and run the following command:

./run_simulations.sh

- This will process all the computations for the given set of initial conditions and parameters. The file `run_simulations.sh' contains the instructions for the .zsh shell to execute the file from TIDES over the range and initial conditions defined above. 
- The output will be a file containing the run number, parameters, and values for the event "maxima x" in a vector of the form (t, x, y, z, w, event).

### 4. Calculate Positive Minima
- Similarly, navigate to the **Find Minima** folder and run:

./run_simulations.sh

- The output will be a file containing the run number, parameters, and values for the event "minima x" in a vector of the form (t, x, y, z, w, event).

### 5. Post-process Data (Maxima)
- In the **Find Maxima** folder, open `import_data.m' in MATLAB to import the output data from TIDES into MATLAB.
- Then, run `create_structure.m' to organise the data into a clean and organised structure, making it easier to work with in MATLAB.
- During this step, negative local maxima will be removed. According to the kneading sequence definition used here, only **positive maxima** are retained.

### 6. Post-process Data (Minima)
- Follow the same steps as in Step 5, but within the **Find Minima** folder.
- This time, positive minima will be removed, keeping only negative minima.

### 7. Merge and Organize Structures
- Navigate back to the main folder and go to the **Merged Data** folder.
- Run `merged_structure.m' to merge the maxima and minima structures from before and generate the final structure `merged_runs.mat'.

### 8. Create Symbolic Kneading Sequences and Kneading Invariant
- Go to the **Create Kneading Sequence** folder and run `create_kneading_matrix.m'.
- This script will:
  1. Convert maxima and minima into symbolic values (+1 or -1).
  2. Organize the results into a clean matrix.
  3. Create and save the `kneading invariant structure'. 
- Each row in the matrix corresponds to a pair of (ρ, μ) values, and each column represents the kneading invariant for different length of symbols.

### 9. Plot Results
- Open the **Plot** folder and run `plot_diagram.m'. Adjust the `n_colors' parameter to select the *level* you want to visualise.
- Use the following functions:
  - `Distinguishable_colors': Creates a color palette that differentiates the levels.
  - `permutecolors': Organizes the colors consistently with the levels.
  - `tightfig': Generates a polished plot with minimal white space.


---
