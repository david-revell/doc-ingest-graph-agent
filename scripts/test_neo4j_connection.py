import sys
from pathlib import Path

# Allow running from repo root without installing as a package
repo_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(repo_root / "src"))

from DB_neo4j import _execute_query, driver


def main() -> None:
    try:
        result = _execute_query(driver, "RETURN 1 as test")
        print("Neo4j connection OK:", result)
    except Exception as exc:
        print("Neo4j connection failed:")
        print(exc)
        raise


if __name__ == "__main__":
    main()
