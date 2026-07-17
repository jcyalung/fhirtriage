# fhirtriage project setup

## Backend
The backend consists of a Python API and a docker container with a HAPI FHIR JPA server and a local Ollama inference engine. 

### Backend Setup
1. Navgiate to the `container/` directory.
2. Launch the docker container using this command:
```bash
docker compose up -d
```
3. Navigate to the `synthea/` directory. You will need to download the `synthea-with-dependencies.jar` through this [link](https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar).
4. Run the command to generate `N` number of patients:
```bash
./generatePatients.sh N
```
5. Then, upload all the generated patients to the FHIR server:
```bash
./storePatients.sh
```

## Setup errors encountered (2026-07-16)

### 1. FHIR server crash loop (blocking)

**Symptom:** `fhirtriage-fhir-server` restarts repeatedly; `curl http://localhost:8080/fhir/metadata` returns `Connection reset by peer` or HTTP 000.

**Log error:**
```
ERROR: syntax error at or near "seq_resource_type"
HAPI-2223: could not extract ResultSet [select next value for seq_resource_type]
```

**Cause:** HAPI defaults to H2 SQL syntax when the Postgres Hibernate dialect is not set.

**Fix:** Add to `container/docker-compose.yml` under `fhir-server.environment`:
```yaml
SPRING_JPA_PROPERTIES_HIBERNATE_DIALECT: ca.uhn.fhir.jpa.model.dialect.HapiFhirPostgresDialect
```
Then recreate with a clean database:
```bash
cd container
docker compose down -v
docker compose up -d
```
Wait ~15–20 seconds after the DB is healthy before hitting the FHIR API.

### 2. Java not available in default shell

**Symptom:** `./generatePatients.sh 10` fails with `Unable to locate a Java Runtime`.

**Fix:** Ensure a JDK is installed and on `PATH`, or set `JAVA_HOME` before running Synthea:
```bash
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
```

### 3. Uploading patients before FHIR is ready

**Symptom:** `./storePatients.sh` prints many `curl: (56) Recv failure: Connection reset by peer` errors.

**Fix:** Confirm the server is up before seeding:
```bash
curl -s -o /dev/null -w '%{http_code}\n' http://localhost:8080/fhir/metadata
# expect 200
```

### 4. `storePatients.sh` false failure on patient count

**Symptom:** Uploads appear to succeed but the script exits with:
```
./storePatients.sh: line 20: [: : integer expression expected
Warning: Mismatch between uploaded JSON files and FHIR server patient count.
```

**Cause:** `Patient?_summary=count` returns `"total": 0` on this HAPI version even when patients exist. The grep yields an empty string.

**Workaround:** Verify manually:
```bash
curl -s "http://localhost:8080/fhir/Patient?_total=accurate&_count=0"
```

### 5. Harmless Synthea warnings

- `SLF4J: No SLF4J providers were found` — safe to ignore.
- `WARNING: sun.reflect.Reflection.getCallerClass is not supported` — safe to ignore.

### 6. Output file count vs patient count

Generating 10 patients produces **12 JSON files** in `synthea/output/fhir/`:
- 10 patient transaction bundles
- 1 `hospitalInformation*.json`
- 1 `practitionerInformation*.json`

`storePatients.sh` uploads all JSON files; expect the file count to exceed the patient count.
