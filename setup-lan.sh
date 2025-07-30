#!/bin/bash

# Künye QR Sistemi - Lokal Ağ Paylaşımı

echo "🌐 Lokal Ağ Paylaşımı kuruluyor..."
echo ""

# IP adresini öğren
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "📡 Sunucu IP adresi: $IP_ADDRESS"

# Firewall portunu aç
echo "🔥 Firewall portu açılıyor..."
sudo ufw allow 8000/tcp
sudo ufw --force enable

# .env dosyasını güncelle - tüm IP'lerden bağlantı kabul et
echo "⚙️  Yapılandırma güncelleniyor..."
if grep -q "HOST=" .env; then
    sed -i 's/HOST=.*/HOST=0.0.0.0/' .env
else
    echo "HOST=0.0.0.0" >> .env
fi

# Port ayarı
if grep -q "PORT=" .env; then
    sed -i 's/PORT=.*/PORT=8000/' .env
else
    echo "PORT=8000" >> .env
fi

# Screen ile başlat
echo "📺 Screen session başlatılıyor..."
screen -S kunye-qr -X quit 2>/dev/null
screen -dmS kunye-qr bash -c 'source venv/bin/activate && python app.py'

# Bekleme
sleep 3

# Durum kontrol
if screen -list | grep -q "kunye-qr"; then
    echo ""
    echo "✅ Lokal ağ paylaşımı başarıyla kuruldu!"
    echo ""
    echo "🌐 Erişim Adresleri:"
    echo "   Lokal:      http://localhost:8000"
    echo "   Lokal Ağ:   http://$IP_ADDRESS:8000"
    echo ""
    echo "📱 Aynı ağdaki cihazlardan erişim için:"
    echo "   - Telefonlar: http://$IP_ADDRESS:8000"
    echo "   - Bilgisayarlar: http://$IP_ADDRESS:8000"
    echo "   - Tabletler: http://$IP_ADDRESS:8000"
    echo ""
    echo "🔧 Yönetim:"
    echo "   screen -r kunye-qr          # Session'a bağlan"
    echo "   screen -S kunye-qr -X quit  # Durdur"
    echo ""
    echo "⚠️  Not: Firewall portu 8000/tcp açıldı"
    
    # QR kod üret
    if command -v qrencode &> /dev/null; then
        echo ""
        echo "📱 QR Kod (Telefon için):"
        qrencode -t ANSI "http://$IP_ADDRESS:8000"
    else
        echo ""
        echo "💡 QR kod görmek için: sudo apt install qrencode"
    fi
else
    echo "❌ Screen session oluşturulamadı!"
    exit 1
fi
