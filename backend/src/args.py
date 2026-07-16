import argparse

def arguments():
    parser = argparse.ArgumentParser(
        description="Run the FastAPI server with custom settings.",
        add_help=True  # This ensures -h/--help is added (which is the default)
    )
    parser.add_argument(
        "-H", "--host", 
        type=str, 
        default="0.0.0.0", 
        help="Host address to bind the server. (default: 0.0.0.0)"
    )
    parser.add_argument(
        "-p", "--port", 
        type=int, 
        default=8000, 
        help="Port to run the server on. (default: 8000)"
    )
    parser.add_argument(
        "-r", "--reload", 
        action="store_true", 
        help="Enable auto-reload for development."
    )
    parser.add_argument(
        "-l", "--log-level", 
        type=str, 
        default="info", 
        choices=["critical", "error", "warning", "info", "debug", "trace"], 
        help="Set the log level. (default: info)"
    )

    args = parser.parse_args()
