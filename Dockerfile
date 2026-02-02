FROM node:20 AS frontend-base
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build


FROM python:3.12-slim AS backend-base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


FROM backend-base AS backend
WORKDIR /app
COPY app app
COPY version.py .
COPY --from=frontend-base /static/dist /app/static/dist
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
