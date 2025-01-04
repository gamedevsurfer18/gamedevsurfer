import requests
from bs4 import BeautifulSoup
import csv
from datetime import date

def fiyatlari_cek(url):
    try:
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.content, "html.parser")

        urunler = []
        for urun_kart in soup.find_all(class_="PLPProductListing_PLPCardParent__GC2qb"): # Yeni ürün kartı sınıfı
            urun_adi_etiketi = urun_kart.find("h2", class_="CProductCard-module_title__u8bMW")
            fiyat_etiketi = urun_kart.select_one("span.CPriceBox-module_price__bYk-c")

            if urun_adi_etiketi and fiyat_etiketi:
                urun_adi = urun_adi_etiketi.text.strip()
                fiyat = fiyat_etiketi.text.strip().replace("₺", "").replace(",", ".")
                urunler.append({"ürün": urun_adi, "fiyat": fiyat})
        if not urunler:
            print("Uygun ürün veya fiyat bilgisi bulunamadı. HTML yapısını ve sınıfları KONTROL EDİN!")
        return urunler

    except requests.exceptions.RequestException as e:
        print(f"Hata: {e}")
        return None

def kaydet_csv(veriler, dosya_adi):
    if veriler:
        bugunun_tarihi = date.today().strftime("%Y-%m-%d")
        dosya_adi = f"{dosya_adi}_{bugunun_tarihi}.csv"
        with open(dosya_adi, "w", newline="", encoding="utf-8") as csvfile:
            alan_adlari = veriler[0].keys() if veriler else []
            if alan_adlari:
                yazici = csv.DictWriter(csvfile, fieldnames=alan_adlari)
                yazici.writeheader()
                for veri in veriler:
                    for alan in alan_adlari:
                        if isinstance(veri[alan], str):
                            veri[alan] = veri[alan].strip().replace("â", "a").replace("î", "i").replace("û", "u").replace("’", "'").replace("’", "'").replace("“", "\"").replace("”", "\"").replace("–", "-") # Daha fazla karakter temizleme
                    yazici.writerow(veri)
                print(f"Veriler {dosya_adi} dosyasına kaydedildi.")
            else:
                print("Kaydedilecek veri bulunamadığı için CSV dosyası oluşturulmadı.")

    else:
        print("Kaydedilecek veri yok.")

if __name__ == "__main__":
    url = "https://www.sokmarket.com.tr/meyve-ve-sebze-c-20"
    dosya_adi = "MarketFiyati"

    urun_fiyatlari = fiyatlari_cek(url)
    kaydet_csv(urun_fiyatlari, dosya_adi)