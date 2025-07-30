#!/bin/bash

# Künye QR Sistemi - Sürekli Çalıştırma Seçenekleri

clear
echo "🎯 Künye QR Sorgulama Sistemi - Sürekli Çalıştırma"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Nasıl sürekli çalıştırmak istiyorsunuz?"
echo ""
echo "1) 🔧 Systemd Service (Önerilen - Linux)"
echo "   - Sistem başlangıcında otomatik başlar"
echo "   - Crash durumunda otomatik yeniden başlar"
echo "   - Profesyonel çözüm"
echo ""
echo "2) 🐳 Docker Container (Taşınabilir)"
echo "   - İzole ortam"
echo "   - Kolay deployment"
echo "   - Tüm platformlarda çalışır"
echo ""
echo "3) 📺 Screen Session (Hızlı)"
echo "   - Anında başlar"
echo "   - Terminal kapanınca devam eder"
echo "   - Geliştirme için ideal"
echo ""
echo "4) ⏰ Crontab + Screen (Boot Otomatik)"
echo "   - Sistem açılışında çalışır"
echo "   - Basit kurulum"
echo "   - Hafif çözüm"
echo ""
echo "5) 🌐 Lokal Ağ Paylaşımı (LAN Access)"
echo "   - Aynı ağdaki herkes erişebilir"
echo "   - IP adresi ile erişim"
echo "   - Ofis/ev ağı için ideal"
echo ""
echo "6) 🔗 Ngrok Tunnel (İnternet Erişimi)"
echo "   - İnternet üzerinden erişim"
echo "   - Geçici URL"
echo "   - Test/demo için ideal"
echo ""
echo "7) ❌ İptal"
echo ""
read -p "Seçiminizi yapın (1-7): " choice

case $choice in
    1)
        echo "🔧 Systemd service kuruluyor..."
        ./install-service.sh
        ;;
    2)
        echo "🐳 Docker kuruluyor..."
        ./docker-setup.sh
        ;;
    3)
        echo "📺 Screen session başlatılıyor..."
        ./run-screen.sh
        ;;
    4)
        echo "⏰ Crontab kuruluyor..."
        ./setup-crontab.sh
        ;;
    5)
        echo "🌐 Lokal ağ paylaşımı kuruluyor..."
        ./setup-lan.sh
        ;;
    6)
        echo "🔗 Ngrok tunnel kuruluyor..."
        ./setup-ngrok.sh
        ;;
    7)
        echo "❌ İptal edildi."
        exit 0
        ;;
    *)
        echo "❌ Geçersiz seçim!"
        exit 1
        ;;
esac
