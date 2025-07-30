#!/bin/bash

# Künye QR Sistemi - Durdurma

echo "⏹️ Künye QR Sistemi Durduruluyor..."
echo "═══════════════════════════════════"

# Screen session'larını kapat
if screen -list | grep -q "kunye-qr"; then
    echo "🔴 Ana uygulama kapatılıyor..."
    screen -X -S "kunye-qr" quit
    echo "✅ Ana uygulama durduruldu"
else
    echo "ℹ️ Ana uygulama zaten çalışmıyor"
fi

if screen -list | grep -q "ngrok"; then
    echo "🔴 Ngrok tunnel kapatılıyor..."
    screen -X -S "ngrok" quit
    echo "✅ Ngrok tunnel durduruldu"
else
    echo "ℹ️ Ngrok tunnel zaten çalışmıyor"
fi

# Port'ları kontrol et
if netstat -tlnp 2>/dev/null | grep -q ":8000 "; then
    echo "⚠️ Port 8000 hala kullanımda"
    PROCESS=$(netstat -tlnp 2>/dev/null | grep ":8000 " | awk '{print $7}' | cut -d'/' -f1)
    if [ -n "$PROCESS" ]; then
        echo "🔪 Process ID: $PROCESS - kapatılıyor..."
        kill -9 $PROCESS 2>/dev/null
    fi
else
    echo "✅ Port 8000 serbest"
fi

echo ""
echo "🏁 Tüm servisler durduruldu!"
echo "💡 Yeniden başlatmak için: ./start.sh"
