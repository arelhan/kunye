# 🎯 Künye QR Sorgulama Sistemi

Modern Python Flask tabanlı web uygulaması ile Türkiye Sağlık Bakanlığı künye numaralarını sorgulayın ve QR kod bilgilerini görüntüleyin.

## ✨ Özellikler

- 🔍 **Gerçek Künye Sorgulama** - Sağlık Bakanlığı API entegrasyonu
- 🌐 **Modern Web Arayüzü** - Responsive ve kullanıcı dostu
- ⚡ **Hızlı Performans** - Optimize edilmiş Flask backend
- 🔒 **CORS Desteği** - Cross-origin güvenlik
- 📱 **Mobil Uyumlu** - Tüm cihazlarda çalışır
- 🚫 **Test Verileri Yok** - Sadece gerçek Bakanlık verileri

## 🚀 Hızlı Başlangıç

### Geliştirme için
```bash
./start.sh
```

### Sürekli Çalıştırma
```bash
./deploy.sh
```

### Manuel Kurulum
```bash
# 1. Virtual environment oluştur
python3 -m venv venv

# 2. Aktive et
source venv/bin/activate

# 3. Paketleri yükle
pip install -r requirements.txt

# 4. Uygulamayı başlat
python app.py
```

## 🔄 Sürekli Çalıştırma Seçenekleri

### 1. Systemd Service (Önerilen)
```bash
./install-service.sh
```
- ✅ Sistem başlangıcında otomatik başlar
- ✅ Crash durumunda yeniden başlar
- ✅ Profesyonel çözüm

### 2. Docker Container
```bash
./docker-setup.sh
```
- ✅ İzole ortam
- ✅ Taşınabilir
- ✅ Kolay deployment

### 3. Screen Session
```bash
./run-screen.sh
```
- ✅ Hızlı başlatma
- ✅ Terminal bağımsız
- ✅ Geliştirme dostu

### 4. Crontab
```bash
./setup-crontab.sh
```
- ✅ Boot otomatik
- ✅ Basit kurulum
- ✅ Hafif çözüm

## 📂 Proje Yapısı

```
kunye/
├── 🐍 app.py                    # Ana Flask uygulaması
├── 📦 requirements.txt          # Python bağımlılıkları
├── ⚙️  .env                     # Ortam değişkenleri
├── 🚀 start.sh                  # Başlatma scripti
├── 📁 static/                   # Frontend dosyaları
│   ├── 🎨 style.css            # CSS stilleri
│   └── ⚡ script.js            # JavaScript kodları
├── 📁 venv/                     # Virtual environment
├── 📁 .github/                  # GitHub yapılandırması
│   └── 📋 copilot-instructions.md
└── 📖 README.md                 # Bu dosya
```

## 🔗 API Endpoints

| Endpoint | Metod | Açıklama |
|----------|-------|----------|
| `/` | GET | Ana sayfa (Web UI) |
| `/api/kunye/{kunye_no}` | GET | Künye bilgilerini getir |
| `/health` | GET | Sunucu durumu |

## 💻 Kullanım

### Web Arayüzü
1. Tarayıcınızda `http://localhost:8000` adresini açın
2. **Geçerli** bir künye numarasını girin
3. "Sorgula" butonuna tıklayın
4. Sonuçları görüntüleyin

⚠️ **Not:** Test verileri kaldırıldı. Sadece Sağlık Bakanlığı sisteminde kayıtlı geçerli künye numaraları sorgulanabilir.

### API Kullanımı
```bash
# Sağlık kontrolü
curl http://localhost:8000/health

# Künye sorgulama (geçerli künye numarası gerekli)
curl http://localhost:8000/api/kunye/{gecerli_kunye_numarasi}
```

### JavaScript Console Komutları
```javascript
// Künye sorgusu çalıştır
kunyeSorgula("gecerli_kunye_numarasi")

// Sunucu durumunu kontrol et
sunucuKontrol()
```

## 🛠️ Geliştirme

### Ortam Değişkenleri (.env)
```bash
DEBUG=True          # Debug modu
PORT=5000          # Port numarası
API_TIMEOUT=10     # API timeout süresi
LOG_LEVEL=INFO     # Log seviyesi
```

### Yeni Özellik Ekleme
1. `app.py` dosyasında yeni endpoint tanımla
2. Frontend'de gerekli JavaScript fonksiyonlarını ekle
3. CSS stillerini güncelle
4. Test et ve dokümante et

### Veri Kaynakları
- **Canlı API**: `https://sbu2.saglik.gov.tr/QR/QR.aspx`
- **HTML Parsing**: BeautifulSoup4 ile
- **Test Verileri**: Kaldırıldı ❌

## 🐛 Sorun Giderme

### Yaygın Hatalar

**Port zaten kullanılıyor:**
```bash
# Farklı port kullan
PORT=8000 python app.py
```

**Virtual environment hatası:**
```bash
# Yeniden oluştur
rm -rf venv
python3 -m venv venv
source venv/bin/activate
```

**Paket yükleme hatası:**
```bash
# Pip'i güncelle
pip install --upgrade pip
pip install -r requirements.txt
```

### Debug Modu

Flask debug modu ile detaylı hata mesajları:
```bash
DEBUG=True python app.py
```

## 🔒 Güvenlik

- ✅ Input validasyonu (alfanumerik karakterler)
- ✅ SQL injection koruması (ORM kullanımı yok)
- ✅ XSS koruması (template escaping)
- ✅ CORS yapılandırması
- ✅ Request timeout limitleri

## 📊 Performans

- ⚡ Ortalama yanıt süresi: ~200ms
- 🔄 Eşzamanlı istek desteği
- 💾 Statik dosya cache
- 🌐 CDN hazır yapı

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/yeni-ozellik`)
3. Commit yapın (`git commit -am 'Yeni özellik eklendi'`)
4. Push yapın (`git push origin feature/yeni-ozellik`)
5. Pull Request oluşturun

## 📜 Lisans

Bu proje eğitim amaçlıdır ve MIT lisansı altında dağıtılmaktadır.

## 🆘 Destek

Sorularınız için:
- 📧 Email: [GitHub Issues](https://github.com/kullanici/kunye-qr/issues)
- 💬 Discussions: Proje tartışma sayfası
- 📖 Wiki: Detaylı dokümantasyon

---

**⭐ Projeyi beğendiyseniz yıldız vermeyi unutmayın!**
