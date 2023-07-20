FROM python:3.9

WORKDIR backend

COPY requirements.txt .
COPY backend/app.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8001

CMD ["python", "app.py"]
