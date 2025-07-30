#!/bin/bash

# Künye QR Sistemi - Screen ile Sürekli Çalıştırma

echo "📺 Screen ile sürekli çalıştırma başlatılıyor..."

# Screen yüklü mü kontrol et
if ! command -v screen &> /dev/null; then
    echo "📦 Screen yükleniyor..."
    sudo apt update
    sudo apt install screen -y
fi

# Mevcut screen session varsa öldür
screen -S kunye-qr -X quit 2>/dev/null

# Yeni screen session başlat
echo "🚀 Yeni screen session başlatılıyor..."
screen -dmS kunye-qr bash -c 'source venv/bin/activate && python app.py'

# Durum kontrol
sleep 2
if screen -list | grep -q "kunye-qr"; then
    echo "✅ Screen session başarıyla oluşturuldu!"
    echo ""
    echo "📋 Yönetim Komutları:"
    echo "   screen -r kunye-qr          # Session'a bağlan"
    echo "   screen -d kunye-qr          # Session'dan ayrıl (Ctrl+A, D)"
    echo "   screen -S kunye-qr -X quit  # Session'ı sonlandır"
    echo "   screen -list                # Tüm session'ları listele"
    echo ""
    echo "🌐 Sistem çalışıyor: http://localhost:8000"
else
    echo "❌ Screen session oluşturulamadı!"
fi
