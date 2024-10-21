FROM python:3.12

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

ARG UID=10001

# Creating a unpriviliged user to run scripts from
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    unprivuser

# Copy the app directory into the working directory
COPY scripts /app/

# Make sure that unprivuser has permission to access everything it needs
RUN chown -R unprivuser:unprivuser /app

# Switching to predetermined unpriviliged user
USER unprivuser

# Running the script
CMD ["python", "echo.py"]