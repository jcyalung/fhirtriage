if [ ! -d "output/fhir" ]; then
  echo "Directory output/fhir does not exist. Aborting."
  exit 1
fi

cd output/fhir

# Count the number of JSON files in the current directory
json_file_count=$(ls -1 *.json 2>/dev/null | wc -l)
for f in *.json; do
  echo "Seeding: $f"
  curl -X POST http://localhost:8080/fhir \
       -H "Content-Type: application/fhir+json" \
       -d @"$f" > /dev/null
done

patient_count=$(curl -s "http://localhost:8080/fhir/Patient?_total=accurate&_count=0" | grep -o '"total":[0-9]*' | grep -o '[0-9]*')
echo "Expected (json files uploaded): $json_file_count"
echo "Actual (patients on FHIR server): $patient_count"
if [ "$json_file_count" -eq "$patient_count" ]; then
  echo "Success: All patients have been uploaded."
  exit 0
else
  echo "Warning: Mismatch between uploaded JSON files and FHIR server patient count."
  exit 1
fi