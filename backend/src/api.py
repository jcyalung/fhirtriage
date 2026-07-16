from fastapi import FastAPI, Request
from args import arguments
import uvicorn
from starlette.responses import JSONResponse

app = FastAPI(openapi_url=None, docs_url=None, redoc_url=None)

@app.get("/")
async def root(request: Request):
    return JSONResponse({"message": "hello world!"}, status_code=200)

if __name__ == "__main__":
    args = arguments()  # Call the arguments() function to parse CLI args

    uvicorn.run(
        "api:app",
        host=args.host,
        port=args.port,
        reload=args.reload,
        log_level=args.log_level
    )
