import argparse
import asyncio
import sys
from pathlib import Path

# Allow running from repo root without installing as a package
repo_root = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(repo_root / "src"))

from pdf_processor import preproc_bank_documents


def main() -> None:
    parser = argparse.ArgumentParser(description="Ingest a folder of PDFs into Neo4j.")
    parser.add_argument("--path", required=True, help="Path to a folder containing PDFs")
    parser.add_argument("--focus", default=None, help="Optional focus prompt for fact extraction")
    parser.add_argument("--fact-label", default="FACT", help="Neo4j label for facts")
    args = parser.parse_args()

    folder_path = Path(args.path)
    if not folder_path.exists() or not folder_path.is_dir():
        raise SystemExit(f"Folder not found: {folder_path}")

    file_list = [p.name for p in folder_path.iterdir() if p.is_file()]
    asyncio.run(
        preproc_bank_documents(
            str(folder_path),
            file_list=file_list,
            focus=args.focus,
            fact_label=args.fact_label,
        )
    )


if __name__ == "__main__":
    main()
