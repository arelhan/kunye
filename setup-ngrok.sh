#!/bin/bash

# Künye QR Sistemi - Ngrok Tunnel

echo "🔗 Ngrok tunnel kuruluyor..."
echo ""

# Ngrok yüklü mü kontrol et
if ! command -v ngrok &> /dev/null; then
    echo "📦 Ngrok yükleniyor..."
    
    # Ngrok'u indir ve yükle
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
    sudo apt update
    sudo apt install ngrok -y
    
    echo ""
    echo "🔑 Ngrok hesabı gerekli!"
    echo "   1. https://ngrok.com adresine gidin"
    echo "   2. Ücretsiz hesap oluşturun"
    echo "   3. Auth token'ı kopyalayın"
    echo ""
    read -p "Auth token'ınızı girin: " auth_token
    
    if [ -n "$auth_token" ]; then
        ngrok config add-authtoken $auth_token
        echo "✅ Auth token kaydedildi"
    else
        echo "❌ Auth token gerekli!"
        exit 1
    fi
fi

# Flask uygulamasını başlat (background)
echo "🚀 Flask uygulaması başlatılıyor..."
screen -S kunye-qr -X quit 2>/dev/null
screen -dmS kunye-qr bash -c 'source venv/bin/activate && python app.py'

# Bekleme
sleep 3

# Ngrok tunnel başlat
echo "🌍 Ngrok tunnel başlatılıyor..."
screen -dmS ngrok-tunnel ngrok http 8000

# Bekleme ve URL'i al
sleep 5

# Ngrok URL'ini öğren
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -n "$NGROK_URL" ]; then
    echo ""
    echo "✅ Ngrok tunnel başarıyla kuruldu!"
    echo ""
    echo "🌍 İnternet Erişim Adresleri:"
    echo "   Public URL: $NGROK_URL"
    echo "   Lokal:      http://localhost:8000"
    echo ""
    echo "📱 Herkes bu adresten erişebilir:"
    echo "   $NGROK_URL"
    echo ""
    echo "🔧 Yönetim:"
    echo "   screen -r kunye-qr      # Flask uygulaması"
    echo "   screen -r ngrok-tunnel  # Ngrok tunnel"
    echo "   http://localhost:4040   # Ngrok dashboard"
    echo ""
    echo "⚠️  Not: Tunnel ücretsiz hesapta 2 saat sonra kapanır"
    
    # QR kod üret
    if command -v qrencode &> /dev/null; then
        echo ""
        echo "📱 QR Kod (Telefon için):"
        qrencode -t ANSI "$NGROK_URL"
    else
        echo ""
        echo "💡 QR kod görmek için: sudo apt install qrencode"
    fi
else
    echo "❌ Ngrok tunnel oluşturulamadı!"
    echo "💡 Manuel kontrol: http://localhost:4040"
fi
