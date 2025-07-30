#!/bin/bash

# Künye QR Sistemi - Hızlı Başlatma

echo "🚀 Künye QR Sistemi Başlatılıyor..."
echo "════════════════════════════════════"

# Gerekli paketleri kontrol et
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 bulunamadı!"
    exit 1
fi

if ! python3 -c "import flask" 2>/dev/null; then
    echo "🔧 Flask yükleniyor..."
    pip3 install flask flask-cors beautifulsoup4 requests
fi

# Var olan session'ları temizle
if screen -list | grep -q "kunye-qr"; then
    echo "⏹️ Var olan session kapatılıyor..."
    screen -X -S "kunye-qr" quit
fi

# Firewall port'unu aç
if command -v ufw &> /dev/null; then
    echo "🔒 Firewall ayarlanıyor..."
    sudo ufw allow 8000/tcp 2>/dev/null
fi

# Uygulamayı screen'de başlat
echo "🌟 Uygulama başlatılıyor..."
screen -dmS "kunye-qr" bash -c 'cd /home/are/Desktop/kunye && python3 app.py'

# Başlatma kontrolü
sleep 2

if screen -list | grep -q "kunye-qr"; then
    echo "✅ Başarıyla başlatıldı!"
    echo ""
    ./network-info.sh
else
    echo "❌ Başlatma başarısız!"
    echo "📋 Log için: screen -r kunye-qr"
fi

# Sunucuyu başlat
echo "🌐 Flask sunucusu başlatılıyor..."
echo "📡 Ana Sayfa: http://localhost:5000"
echo "🔍 API: http://localhost:5000/api/kunye/{kunye_no}"
echo "🧪 Test: http://localhost:5000/api/test"
echo "❤️  Sağlık: http://localhost:5000/health"
echo ""
echo "💡 Çıkmak için Ctrl+C tuşlayın"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

python app.py
