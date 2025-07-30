"""
Künye QR Sorgulama Sistemi - Flask Backend
Türkiye Sağlık Bakanlığı künye numaralarını sorgular ve QR bilgilerini getirir.
"""

from flask import Flask, request, jsonify, render_template_string
from flask_cors import CORS
import requests
from bs4 import BeautifulSoup
import re
import os
from dotenv import load_dotenv
import logging

# Environment variables yükle
load_dotenv()

# Flask uygulamasını oluştur
app = Flask(__name__)
CORS(app)

# Logging yapılandırması
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Test verileri kaldırıldı - sadece gerçek API kullanılacak

def kunye_verilerini_parse_et(html_icerigi):
    """HTML içeriğinden künye verilerini parse eder - belirtilen alanlar hariç"""
    try:
        soup = BeautifulSoup(html_icerigi, 'html.parser')
        tum_veriler = {}
        
        # Method 1: Tablo verilerini bul
        tablolar = soup.find_all('table')
        for tablo in tablolar:
            satirlar = tablo.find_all('tr')
            for satir in satirlar:
                hücreler = satir.find_all('td')
                if len(hücreler) >= 2:
                    etiket = hücreler[0].get_text(strip=True)
                    değer = hücreler[1].get_text(strip=True)
                    if etiket and değer and etiket != değer:
                        tum_veriler[etiket] = değer
        
        # Gösterilmeyecek alanlar (hariç tutulacaklar)
        haric_tutulacak_alanlar = [
            'İLK TEDARİK BİLGİLERİ',
            'TEDARİKÇİ FİRMA', 
            'TEDARİKÇİ TÜRÜ',
            'MALZEME AÇIKLAMA',
            'KÜNYE AÇIKLAMA',
            'KURUM KODU',
            'KURUM ADI',
            'HAREKET DETAYLARI',
            'ÜRETİM TARİHİ',
            'DEMİRBAŞ NO'
        ]
        
        # Hariç tutulan alanları filtrele
        filtrelenmis_veriler = {}
        for etiket, değer in tum_veriler.items():
            if etiket not in haric_tutulacak_alanlar:
                filtrelenmis_veriler[etiket] = değer
        
        return filtrelenmis_veriler
    except Exception as e:
        logger.error(f"HTML parse hatası: {str(e)}")
        return {}

def kunye_numarasi_gecerli_mi(kunye_no):
    """Künye numarası format kontrolü"""
    return bool(re.match(r'^[A-Za-z0-9]+$', kunye_no))

@app.route('/')
def ana_sayfa():
    """Ana sayfa - Web uygulaması arayüzü"""
    return render_template_string("""
    <!DOCTYPE html>
    <html lang="tr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Künye QR Sorgulama Sistemi</title>
        <link rel="stylesheet" href="/static/style.css">
    </head>
    <body>
        <div class="container">
            <header class="header">
                <h1>🔍 Künye QR Sorgulama Sistemi</h1>
                <p>Sağlık Bakanlığı künye numaralarını sorgulayın</p>
            </header>
            
            <main class="main">
                <div class="arama-kutusu">
                    <input type="text" id="kunyeInput" placeholder="Künye numarasını giriniz (gerçek veri)" maxlength="20">
                    <button id="sorgulaBtn">🔍 Sorgula</button>
                </div>
                
                <div id="sonuclar" class="sonuclar gizli">
                    <h2>📋 Künye Bilgileri</h2>
                    <div id="sonucIcerik" class="sonuc-icerik"></div>
                </div>
                
                <div id="hata" class="hata gizli">
                    <p id="hataMesaji"></p>
                </div>
                
                <div id="yukleniyor" class="yukleniyor gizli">
                    <div class="spinner"></div>
                    <p>Veriler getiriliyor...</p>
                </div>
            </main>
        </div>
        
        <script src="/static/script.js"></script>
    </body>
    </html>
    """)

@app.route('/api/kunye/<kunye_no>')
def kunye_sorgula(kunye_no):
    """Künye numarası sorgulama API endpoint'i"""
    try:
        # Künye numarası validasyonu
        if not kunye_numarasi_gecerli_mi(kunye_no):
            return jsonify({
                'hata': 'Geçersiz künye numarası formatı',
                'durum': 'hata'
            }), 400
        
        logger.info(f"Künye sorgulanıyor: {kunye_no}")
        
        # Doğrudan gerçek API'ye istek gönder
        url = f"https://sbu2.saglik.gov.tr/QR/QR.aspx?kno={kunye_no}"
        
        basliklar = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language': 'tr-TR,tr;q=0.9,en;q=0.8',
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1'
        }
        
        yanit = requests.get(url, headers=basliklar, timeout=10)
        yanit.raise_for_status()
        
        # HTML'den veri parse et
        parse_edilen_veriler = kunye_verilerini_parse_et(yanit.text)
        
        if parse_edilen_veriler:
            logger.info(f"Gerçek veri döndürülüyor: {kunye_no}")
            return jsonify({
                'veriler': parse_edilen_veriler,
                'kunye_no': kunye_no,
                'durum': 'basarili',
                'kaynak': 'api'
            })
        else:
            return jsonify({
                'hata': 'Künye bilgileri bulunamadı',
                'kunye_no': kunye_no,
                'durum': 'bulunamadi'
            }), 404
            
    except requests.exceptions.Timeout:
        return jsonify({
            'hata': 'Bağlantı zaman aşımı',
            'durum': 'timeout'
        }), 408
    except requests.exceptions.RequestException as e:
        logger.error(f"API isteği hatası: {str(e)}")
        return jsonify({
            'hata': f'Bağlantı hatası: {str(e)}',
            'durum': 'baglanti_hatasi'
        }), 503
    except Exception as e:
        logger.error(f"Beklenmeyen hata: {str(e)}")
        return jsonify({
            'hata': f'Beklenmeyen hata: {str(e)}',
            'durum': 'hata'
        }), 500

@app.route('/health')
def saglik_kontrolu():
    """Sunucu sağlık durumu kontrolü"""
    return jsonify({
        'durum': 'saglikli',
        'mesaj': 'Künye QR Sorgulama Sistemi çalışıyor',
        'versiyon': '1.0.0'
    })

@app.route('/static/<path:filename>')
def statik_dosyalar(filename):
    """Statik dosyaları serve et"""
    from flask import send_from_directory
    return send_from_directory('static', filename)

if __name__ == '__main__':
    # Geliştirme sunucusunu başlat
    port = int(os.environ.get('PORT', 8000))
    host = os.environ.get('HOST', '0.0.0.0')  # Tüm IP'lerden erişim
    debug_mode = os.environ.get('DEBUG', 'True').lower() == 'true'
    
    print("🚀 Künye QR Sorgulama Sistemi başlatılıyor...")
    print(f"📡 Ana Sayfa: http://localhost:{port}")
    print(f"🔍 API Endpoint: http://localhost:{port}/api/kunye/{{kunye_no}}")
    print(f"❤️  Sağlık Kontrolü: http://localhost:{port}/health")
    print(f"🌐 Gerçek API kullanılıyor - Test verileri kaldırıldı")
    print(f"⚠️  Not: Sadece geçerli künye numaraları sorgulanabilir")
    print(f"🌐 Host: {host}:{port} (LAN erişimi için 0.0.0.0)")
    
    app.run(
        host=host,
        port=port,
        debug=debug_mode
    )
