#!/bin/bash

# Künye QR Sistemi - Systemd Service Kurulum

echo "🔧 Systemd service kurulumu başlatılıyor..."

# Service dosyasını systemd dizinine kopyala
sudo cp kunye-qr.service /etc/systemd/system/

# Systemd daemon'ı yeniden yükle
sudo systemctl daemon-reload

# Service'i etkinleştir (boot'ta otomatik başlasın)
sudo systemctl enable kunye-qr.service

# Service'i başlat
sudo systemctl start kunye-qr.service

# Durum kontrolü
sudo systemctl status kunye-qr.service

echo ""
echo "✅ Service kurulumu tamamlandı!"
echo ""
echo "📋 Yönetim Komutları:"
echo "   sudo systemctl start kunye-qr     # Başlat"
echo "   sudo systemctl stop kunye-qr      # Durdur"
echo "   sudo systemctl restart kunye-qr   # Yeniden başlat"
echo "   sudo systemctl status kunye-qr    # Durum kontrol"
echo "   sudo systemctl disable kunye-qr   # Otomatik başlatmayı kapat"
echo ""
echo "🌐 Sistem artık sürekli çalışacak: http://localhost:8000"
