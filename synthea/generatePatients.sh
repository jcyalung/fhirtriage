#!/bin/bash

NUM_PATIENTS=$1


if [ -z "$NUM_PATIENTS" ]; then 
    echo "Num patients required: generatePatients.sh [NUM_PATIENTS]"
    exit 1
fi

echo "Creating $NUM_PATIENTS synthetic patient(s)"
if [ ! -f "src/synthea-with-dependencies.jar" ]; then
    echo "Error: Synthea JAR not found at src/synthea-with-dependencies.jar"
    echo "Please download the Synthea JAR before running this script."
    exit 1
fi

java -jar src/synthea-with-dependencies.jar -p $NUM_PATIENTS --exporter.fhir.transaction_bundle=true
echo "Successful operation."
exit 0
