#!/bin/bash

# Directory where outputs will be stored
OUTPUT_DIR="DATAP"

# Path to the parameter file
PARAM_FILE="data2.par"

# Number of mass steps N and lambda steps M
N=101  # Number of steps for Mdm1 (mass)
M=101  # Number of steps for laSH (lambda_SH)

# Mass range (Mdm1)
START_MASS=40
END_MASS=4800

# Lambda range (laSH)
START_LAMBDA=0.003
END_LAMBDA=10  # Adjust this to your desired end value for laSH

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Initialize output file counter
output_number=1

# Compute logarithms of start and end values for masses
START_MASS_LOG=$(bc -l <<< "l($START_MASS)/l(10)")
END_MASS_LOG=$(bc -l <<< "l($END_MASS)/l(10)")
MASS_STEP_LOG=$(bc -l <<< "($END_MASS_LOG - $START_MASS_LOG)/($N - 1)")

# Compute logarithms of start and end values for lambdas
START_LAMBDA_LOG=$(bc -l <<< "l($START_LAMBDA)/l(10)")
END_LAMBDA_LOG=$(bc -l <<< "l($END_LAMBDA)/l(10)")
LAMBDA_STEP_LOG=$(bc -l <<< "($END_LAMBDA_LOG - $START_LAMBDA_LOG)/($M - 1)")

# Outer loop over laSH (lambda_SH)
for ((j=0; j<M; j++)); do
    # Compute current laSH value in logarithmic scale
    varL_LAMBDA=$(bc -l <<< "$START_LAMBDA_LOG + $j * $LAMBDA_STEP_LOG")
    laSH=$(bc -l <<< "e($varL_LAMBDA * l(10))")

    # Update laSH in data2.par
    sed -i -e "s/^laSH .*/laSH   $laSH/" "$PARAM_FILE"

    # Inner loop over Mdm1 (mass)
    for ((i=0; i<N; i++)); do
        # Compute current Mdm1 value in logarithmic scale
        varL_MASS=$(bc -l <<< "$START_MASS_LOG + $i * $MASS_STEP_LOG")
        Mdm1=$(bc -l <<< "e($varL_MASS * l(10))")

        # Update Mdm1 in data2.par
        sed -i -e "s/^Mdm1 .*/Mdm1   $Mdm1/" "$PARAM_FILE"

        # Run the main program and save output
        ./main "$PARAM_FILE" > "${OUTPUT_DIR}/output_${output_number}.txt"

        # Increment output file counter
        ((output_number++))
    done
done

echo "Process completed. Outputs are saved in the folder '$OUTPUT_DIR'."

