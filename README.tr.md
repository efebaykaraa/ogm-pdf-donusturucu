# OGM ZIP Dosyalarını PDF'ye Dönüştürme

OGM Materyal web sitesinden indirdiğiniz ZIP dosyalarını PDF dosyalarına dönüştürür.

## Gereksinimler

- Windows işletim sistemi
- PowerShell
- Microsoft Print to PDF yazıcısı

## Dosya Yapısı
```
Convert-Images-to-PDF
├── windows
│   ├── bin
│   │   ├── convert_images_gui.ps1
│   │   ├── convert_images_to_pdf.ps1
│   │   └── prepare_images.bat
│   ├── ogm_to_pdf.bat
├── linux
│   ├── ogm_to_pdf.sh
├── LICENSE
└── README.tr.md
```

## Kullanım

### Adım 1: Dosyaları Ayarlayın

Bu depoyu klonlayın veya ZIP dosyasını indirip istediğiniz bir dizine çıkarın.
```shell
git clone https://github.com/efexplose/ogm-pdf-donusturucu
```

### Windows'ta:

1. `ogm_to_pdf.bat` dosyasını çift tıklayarak çalıştırın.
2. GUI'de dili seçin (İngilizce veya Türkçe).
3. Görüntüleri içeren ZIP dosyasının yolunu belirtin.
4. PDF dosyası için istenen çıkış yolunu belirtin.
5. Dönüştürme işlemini başlatmak için `Dönüştür` düğmesine tıklayın.

### Linux'ta:

1. `ogm_to_pdf.sh` dosyasını bir terminalde çalıştırın.
2. GUI'de dili seçin (İngilizce veya Türkçe).
3. Görüntüleri içeren ZIP dosyasının yolunu belirtin.
4. PDF dosyası için istenen çıkış yolunu belirtin.
5. Dönüştürme işlemini başlatmak için `Dönüştür` düğmesine tıklayın.