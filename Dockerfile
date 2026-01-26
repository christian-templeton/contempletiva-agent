FROM ghcr.io/astral-sh/uv:python3.13-bookworm



COPY pyproject.toml uv.lock README.md ./
COPY src src

RUN \
    --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked

RUN uv add python-dotenv gymnasium \
    "tau2 @ git+https://github.com/sierra-research/tau2-bench" \
    "agentify-tau-bench @ git+https://github.com/sierra-research/tau2-bench#subdirectory=src/experiments/agentify_tau_bench"

RUN mkdir -p /tmp/tau2-bench && \
    curl -L https://github.com/sierra-research/tau2-bench/archive/refs/heads/main.tar.gz | \
    tar -xz --strip-components=1 -C /tmp/tau2-bench && \
    mkdir -p ./.venv/lib/python3.13/data/tau2 && \
    cp -r /tmp/tau2-bench/src/tau2/domains ./.venv/lib/python3.13/data/tau2/ && \
    rm -rf /tmp/tau2-bench

ENTRYPOINT ["uv", "run", "src/server.py"]
CMD ["--host", "0.0.0.0"]
EXPOSE 9009
