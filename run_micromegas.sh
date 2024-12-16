#!/bin/bash

# Directorio donde se guardarán los outputs
OUTPUT_DIR="DATALINEAL3"


# Ruta del archivo de parámetros
PARAM_FILE="data2.par"

# Rango y paso de Mdm1
START=50
END=80
STEP=0.3

# Iterador para el número de output
output_number=1

# Bucle para modificar Mdm1 y ejecutar ./main
for Mdm1 in $(seq $START $STEP $END); do
    # Modificar el archivo data2.par con el nuevo valor de Mdm1
    sed -i "s/^Mdm1 .*/Mdm1   $Mdm1/" "$PARAM_FILE"

    # Ejecutar el programa y guardar la salida en el archivo correspondiente
    ./main "$PARAM_FILE" > "${OUTPUT_DIR}/output_${output_number}.txt"

    # Incrementar el número de output
    ((output_number++))
done

echo "Proceso completado. Los outputs están en la carpeta $OUTPUT_DIR."

