# Beginner Notes

This doc explains a few repo conventions and files that might be new.

## What is `src/`?
`src/` stands for "source". It keeps application code in one place and reduces import surprises.
You still run files from the repo root (for example, `python src/chatbot_framework.py`).

## What is `pyproject.toml`?
`pyproject.toml` is a standard project metadata file in Python. It can:
- describe the project (name, version)
- declare dependencies
- store tool configuration

This repo keeps `requirements.txt` as the simplest install path, but `pyproject.toml`
exists so tools can read project metadata consistently.

## What is `__init__.py`?
`__init__.py` marks a folder as a Python package. It allows:
- `import` to work reliably from that folder
- tools to recognize the package

We keep it empty unless we need package-level helpers later.

## What is `scripts/`?
The `scripts/` folder is for small runnable tools. These are not part of the core library,
but they make it easy to run common tasks without editing code.

Example: run ingestion on a folder of PDFs

```powershell
python .\scripts\ingest_folder.py --path "C:\path\to\pdfs"
```
