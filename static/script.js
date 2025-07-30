// Künye QR Sorgulama Sistemi - JavaScript

class KunyeSorgulamaSistemi {
    constructor() {
        this.apiBaseUrl = window.location.origin;
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.focusInput();
    }

    setupEventListeners() {
        const input = document.getElementById('kunyeInput');
        const button = document.getElementById('sorgulaBtn');

        // Sorgula butonu click eventi
        button.addEventListener('click', () => this.kunyeSorgula());

        // Enter tuşu ile sorgulama
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.kunyeSorgula();
            }
        });

        // Input temizleme ve validasyon
        input.addEventListener('input', (e) => {
            // Sadece alfanumerik karakterlere izin ver
            e.target.value = e.target.value.replace(/[^a-zA-Z0-9]/g, '');
        });
    }

    focusInput() {
        document.getElementById('kunyeInput').focus();
    }

    async kunyeSorgula() {
        const kunyeNo = document.getElementById('kunyeInput').value.trim();
        
        if (!kunyeNo) {
            this.hataGoster('Lütfen bir künye numarası giriniz');
            return;
        }

        if (kunyeNo.length < 5) {
            this.hataGoster('Künye numarası en az 5 karakter olmalıdır');
            return;
        }

        try {
            this.yuklemeGoster();
            
            const response = await fetch(`${this.apiBaseUrl}/api/kunye/${kunyeNo}`);
            const data = await response.json();
            
            if (response.ok && data.durum === 'basarili') {
                this.sonuclariGoster(data);
            } else {
                this.hataGoster(data.hata || 'Bilinmeyen bir hata oluştu');
            }
        } catch (error) {
            console.error('API Hatası:', error);
            this.hataGoster('Sunucuya bağlanılamadı. Lütfen tekrar deneyin.');
        } finally {
            this.yuklemeGizle();
        }
    }

    sonuclariGoster(data) {
        const sonuclarDiv = document.getElementById('sonuclar');
        const sonucIcerikDiv = document.getElementById('sonucIcerik');
        
        // Mevcut içeriği temizle
        sonucIcerikDiv.innerHTML = '';
        
        // Tüm verileri göster (filtrelenmiş)
        Object.entries(data.veriler).forEach(([etiket, deger]) => {
            const satirDiv = document.createElement('div');
            satirDiv.className = 'veri-satiri';
            satirDiv.innerHTML = `
                <span class="veri-etiket">${etiket}:</span>
                <span class="veri-deger">${deger}</span>
            `;
            sonucIcerikDiv.appendChild(satirDiv);
        });
        
        // Kaynak bilgisini ekle (sadece gerçek API)
        if (data.kaynak) {
            const kaynakDiv = document.createElement('div');
            kaynakDiv.className = 'test-bilgisi';
            kaynakDiv.innerHTML = `
                <strong>Veri Kaynağı:</strong> 
                <span class="kaynak-bilgisi kaynak-api">Canlı API</span>
                <br><small>Bu veri Sağlık Bakanlığı sisteminden gerçek zamanlı olarak alınmıştır.</small>
                <br><small>Not: İLK tedarik bilgileri, tedarikçi firma, tedarikçi türü, malzeme açıklama, künye açıklama, kurum kodu, kurum adı, hareket detayları, üretim tarihi ve demirbaş no alanları gizlenmiştir.</small>
            `;
            sonucIcerikDiv.appendChild(kaynakDiv);
        }
        
        // Sonuçları göster
        this.elementleriGizleGoster(['hata'], ['sonuclar']);
        
        // Sonuca scroll et
        sonuclarDiv.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    hataGoster(mesaj) {
        const hataDiv = document.getElementById('hata');
        const hataMesajiP = document.getElementById('hataMesaji');
        
        hataMesajiP.textContent = mesaj;
        this.elementleriGizleGoster(['sonuclar'], ['hata']);
        
        // Hataya scroll et
        hataDiv.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    yuklemeGoster() {
        const button = document.getElementById('sorgulaBtn');
        button.disabled = true;
        button.textContent = '⏳ Sorgulanıyor...';
        
        this.elementleriGizleGoster(['sonuclar', 'hata'], ['yukleniyor']);
    }

    yuklemeGizle() {
        const button = document.getElementById('sorgulaBtn');
        button.disabled = false;
        button.textContent = '🔍 Sorgula';
        
        this.elementleriGizleGoster(['yukleniyor'], []);
    }

    elementleriGizleGoster(gizlenecekler = [], gosterilecekler = []) {
        // Elementleri gizle
        gizlenecekler.forEach(id => {
            const element = document.getElementById(id);
            if (element) {
                element.classList.add('gizli');
            }
        });
        
        // Elementleri göster
        gosterilecekler.forEach(id => {
            const element = document.getElementById(id);
            if (element) {
                element.classList.remove('gizli');
            }
        });
    }

    async sunucuDurumuKontrolEt() {
        try {
            const response = await fetch(`${this.apiBaseUrl}/health`);
            const data = await response.json();
            console.log('Sunucu durumu:', data);
            return data.durum === 'saglikli';
        } catch (error) {
            console.error('Sunucu durumu kontrol edilemedi:', error);
            return false;
        }
    }
}

// Sayfa yüklendiğinde sistemi başlat
document.addEventListener('DOMContentLoaded', () => {
    window.kunyeSistemi = new KunyeSorgulamaSistemi();
    
    // Global fonksiyonlar - console'dan kullanım için
    window.kunyeSorgula = (kunyeNo) => {
        if (kunyeNo) {
            document.getElementById('kunyeInput').value = kunyeNo;
        }
        window.kunyeSistemi.kunyeSorgula();
    };
    
    window.sunucuKontrol = () => {
        window.kunyeSistemi.sunucuDurumuKontrolEt();
    };
    
    console.log('🎯 Künye QR Sorgulama Sistemi hazır!');
    console.log('💡 Kullanılabilir komutlar:');
    console.log('   kunyeSorgula("künye_numarası") - Künye sorgusu çalıştır');
    console.log('   sunucuKontrol() - Sunucu durumunu kontrol et');
    console.log('⚠️  Not: Test verileri kaldırıldı, sadece gerçek API kullanılıyor');
});
