#!/bin/bash

# Künye QR Sistemi - Crontab Kurulum

echo "⏰ Crontab kurulumu başlatılıyor..."

# Mevcut crontab'ı backup al
crontab -l > crontab_backup_$(date +%Y%m%d_%H%M%S).txt 2>/dev/null

# Yeni crontab entry ekle
(crontab -l 2>/dev/null; echo "@reboot cd /home/are/Desktop/kunye && ./run-screen.sh") | crontab -

echo "✅ Crontab kurulumu tamamlandı!"
echo ""
echo "📋 Eklenen kural:"
echo "   @reboot cd /home/are/Desktop/kunye && ./run-screen.sh"
echo ""
echo "🔄 Sistem yeniden başlatıldığında otomatik çalışacak"
echo "💡 Şimdi manuel başlatmak için: ./run-screen.sh"
