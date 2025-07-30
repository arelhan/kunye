FROM python:3.12-slim

# Çalışma dizini
WORKDIR /app

# Sistem paketlerini güncelle
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Python bağımlılıklarını kopyala ve yükle
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Uygulama dosyalarını kopyala
COPY . .

# Port açık
EXPOSE 8000

# Uygulama başlat
CMD ["python", "app.py"]
