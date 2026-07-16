# FHIRtriage
A stateful multi-agent system built with Next.js and LangGraph that leverages clinical NLP to map natural language symptoms to ICD-10 codes and utilize a LightGBM classifier to determine safe triage decisions.

## Tech Stack
### Frontend
- Next.js with App Router
- TailwindCSS 
- Server-Sent Events (SSE) native web API
### Backend
- FastAPI (Py3.11)
- LangGraph v1.2
- Pydantic v2
- `fhripy`
### ML & AI
- XGBoost (with `scikit-learn`)
- `shap`
- Llama 3.1 (8B), or DeepSeek-R1
### Infra and Database
- Docker
- HAPI FHIR JPA
- Synthea
- PostgreSQL with `pgvector`
- Ollama