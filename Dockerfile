FROM python:3.11-slim

WORKDIR /app

# System deps (for FAISS, etc.)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Installa uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copia i file di configurazione
COPY pyproject.toml uv.lock /app/

# Installa dipendenze con uv (molto più veloce!)
RUN uv sync --frozen --no-dev

# Copia il resto dell'applicazione
COPY . /app

ENV PYTHONUNBUFFERED=1
ENV STREAMLIT_SERVER_PORT=8501
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0

EXPOSE 8501

# Esegui con uv run
CMD ["uv", "run", "streamlit", "run", "app.py"]
