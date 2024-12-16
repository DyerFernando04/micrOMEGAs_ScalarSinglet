#!/bin/bash

# Directorio donde se almacenarán las salidas
OUTPUT_DIR="DATAP"

# Archivo de parámetros
PARAM_FILE="data2.par"

# Pasos para N (masa) y M (lambda)
N=101
M=101

# Rango de masa (Mdm1)
START_MASS=40
END_MASS=4800

# Rango de lambda (laSH)
START_LAMBDA=0.003
END_LAMBDA=10

# Crear el directorio si no existe
mkdir -p "$OUTPUT_DIR"

# Contador de archivo de salida
output_number=1

# Cálculo de valores logarítmicos para la masa
START_MASS_LOG=$(bc -l <<< "l($START_MASS)/l(10)")
END_MASS_LOG=$(bc -l <<< "l($END_MASS)/l(10)")
MASS_STEP_LOG=$(bc -l <<< "($END_MASS_LOG - $START_MASS_LOG)/($N - 1)")

# Cálculo de valores logarítmicos para la lambda
START_LAMBDA_LOG=$(bc -l <<< "l($START_LAMBDA)/l(10)")
END_LAMBDA_LOG=$(bc -l <<< "l($END_LAMBDA)/l(10)")
LAMBDA_STEP_LOG=$(bc -l <<< "($END_LAMBDA_LOG - $START_LAMBDA_LOG)/($M - 1)")

# Bucle externo sobre laSH
for ((j=0; j<M; j++)); do
    # Calcular laSH según escala logarítmica
    varL_LAMBDA=$(bc -l <<< "$START_LAMBDA_LOG + $j * $LAMBDA_STEP_LOG")
    laSH=$(bc -l <<< "e($varL_LAMBDA * l(10))")

    # Crear una nueva variable laSH_double
    laSH_double=$(bc -l <<< "$laSH * 2")

    # Actualizar data2.par con laSH_double (no con laSH para no alterar el escalado)
    sed -i -e "s/^laSH .*/laSH   $laSH_double/" "$PARAM_FILE"

    # Bucle interno sobre Mdm1
    for ((i=0; i<N; i++)); do
        varL_MASS=$(bc -l <<< "$START_MASS_LOG + $i * $MASS_STEP_LOG")
        Mdm1=$(bc -l <<< "e($varL_MASS * l(10))")

        sed -i -e "s/^Mdm1 .*/Mdm1   $Mdm1/" "$PARAM_FILE"

        # Ejecutar el programa principal con laSH duplicado
        ./main "$PARAM_FILE" > "${OUTPUT_DIR}/output_${output_number}.txt"

        ((output_number++))
    done

    # Opcional: restaurar laSH original en el archivo, no es estrictamente necesario
    # puesto que la próxima iteración recalculará laSH.
    sed -i -e "s/^laSH .*/laSH   $laSH/" "$PARAM_FILE"

done

echo "Proceso completado. Las salidas se guardaron en la carpeta '$OUTPUT_DIR'."

