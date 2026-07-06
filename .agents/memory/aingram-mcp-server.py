#!/usr/bin/env python3
"""AIngram MCP Server Wrapper — exposes AIngram as an MCP stdio server."""

import argparse
import sys
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(description="AIngram MCP Server")
    parser.add_argument(
        "--db", required=True, help="Path to AIngram SQLite database"
    )
    parser.add_argument(
        "mcp", nargs="?", help="Positional argument (ignored, for opencode compat)"
    )
    args = parser.parse_args()

    db_path = Path(args.db).resolve()
    db_path.parent.mkdir(parents=True, exist_ok=True)

    try:
        from aingram.mcp_server import create_server

        server = create_server(
            db_path=str(db_path),
            require_auth=False,
        )
        server.run()  # runs stdio transport by default
    except ImportError as e:
        print(
            f"Error: AIngram MCP module not available. "
            f"Did you install with `pip install aingram[mcp]`?\nDetails: {e}",
            file=sys.stderr,
        )
        sys.exit(1)
    except Exception as e:
        print(f"Error starting AIngram MCP server: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
