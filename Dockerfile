FROM ghcr.io/astral-sh/uv:python3.13-bookworm

WORKDIR /app

COPY pyproject.toml README.md ./
COPY src src

RUN uv pip compile pyproject.toml -o uv.lock

RUN \
    --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked


ENTRYPOINT ["uv", "run"]
CMD ["src/server.py", "--host", "0.0.0.0", "--port", "9009"]
EXPOSE 9009
