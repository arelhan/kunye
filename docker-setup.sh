#!/bin/bash

# Künye QR Sistemi - Docker Kurulum

echo "🐳 Docker kurulumu başlatılıyor..."

# Docker yüklü mü kontrol et
if ! command -v docker &> /dev/null; then
    echo "❌ Docker yüklü değil. Önce Docker kurmalısınız:"
    echo "   sudo apt update"
    echo "   sudo apt install docker.io docker-compose"
    exit 1
fi

# Docker build
echo "📦 Docker image oluşturuluyor..."
docker-compose build

# Container başlat
echo "🚀 Container başlatılıyor..."
docker-compose up -d

# Durum kontrol
echo "📊 Container durumu:"
docker-compose ps

echo ""
echo "✅ Docker kurulumu tamamlandı!"
echo ""
echo "📋 Yönetim Komutları:"
echo "   docker-compose up -d        # Arka planda başlat"
echo "   docker-compose down         # Durdur"
echo "   docker-compose restart      # Yeniden başlat"
echo "   docker-compose logs -f      # Logları izle"
echo ""
echo "🌐 Sistem çalışıyor: http://localhost:8000"
