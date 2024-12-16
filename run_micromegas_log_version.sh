#!/bin/bash

# Directorio donde se guardarán los outputs
OUTPUT_DIR="DATA3"

# Ruta del archivo de parámetros
PARAM_FILE="data2.par"

# Número de puntos N
N=101

# Valores de inicio y fin para Mdm1
START=45
END=1000

# Cálculo de startL, endL y stepL usando bc para precisión decimal
STARTL=$(echo "l($START)/l(10)" | bc -l)
ENDL=$(echo "l($END)/l(10)" | bc -l)
STEPL=$(echo "($ENDL - $STARTL)/($N - 1)" | bc -l)

#quitar el echo


# Iterador para el número de output
output_number=1

# Bucle para modificar Mdm1 y ejecutar ./main
for ((i=0; i<N; i++)); do
    # Calcular varL = startL + i * stepL
    varL=$(echo "$STARTL + $i * $STEPL" | bc -l)

    # Calcular Mdm1 = 10^varL usando e^(varL * ln(10))
    Mdm1=$(echo "e($varL * l(10))" | bc -l)

    # Modificar el archivo data2.par con el nuevo valor de Mdm1
    sed -i "s/^Mdm1 .*/Mdm1   $Mdm1/" "$PARAM_FILE"

    # Ejecutar el programa y guardar la salida en el archivo correspondiente
    ./main "$PARAM_FILE" > "${OUTPUT_DIR}/output_${output_number}.txt"

    # Incrementar el número de output
    ((output_number++))
done

echo "Proceso completado. Los outputs están en la carpeta $OUTPUT_DIR."

