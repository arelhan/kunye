#!/bin/bash

# Künye QR Sistemi - Ağ Bilgileri

echo "🌐 Ağ Erişim Bilgileri"
echo "═══════════════════════"
echo ""

# IP adreslerini öğren
LOCAL_IP=$(hostname -I | awk '{print $1}')
PUBLIC_IP=$(curl -s https://ipinfo.io/ip 2>/dev/null || echo "Bulunamadı")

echo "📡 Lokal IP: $LOCAL_IP"
echo "🌍 Genel IP: $PUBLIC_IP"
echo ""

# Port kontrolü
if netstat -tlnp 2>/dev/null | grep -q ":8000 "; then
    echo "✅ Port 8000 aktif"
    echo ""
    echo "🔗 Erişim Adresleri:"
    echo "   Lokal:      http://localhost:8000"
    echo "   LAN:        http://$LOCAL_IP:8000"
    echo ""
    echo "📱 Aynı ağdaki cihazlar için:"
    echo "   http://$LOCAL_IP:8000"
    
    # QR kod
    if command -v qrencode &> /dev/null; then
        echo ""
        echo "📱 QR Kod:"
        qrencode -t ANSI "http://$LOCAL_IP:8000"
    fi
else
    echo "❌ Port 8000 aktif değil"
    echo "💡 Önce sistemi başlatın: ./start.sh veya ./deploy.sh"
fi

echo ""
echo "🔧 Sistem durumu:"
if screen -list | grep -q "kunye-qr"; then
    echo "   Screen session: ✅ Çalışıyor"
else
    echo "   Screen session: ❌ Çalışmıyor"
fi

# Ngrok kontrolü
if screen -list | grep -q "ngrok"; then
    echo "   Ngrok tunnel: ✅ Çalışıyor"
    NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | head -1 | cut -d'"' -f4)
    if [ -n "$NGROK_URL" ]; then
        echo "   Public URL: $NGROK_URL"
    fi
else
    echo "   Ngrok tunnel: ❌ Çalışmıyor"
fi
