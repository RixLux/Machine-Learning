# Tugas 10b

## **Review Perkembangan Arsitektur Deep Learning: Analisis Komparatif CNN dan RNN (2021-2026)**

### **1. Pendahuluan**
Dalam paruh dekade terakhir, *Deep Learning* (DL) telah merevolusi paradigma pemrosesan data kompleks melalui kemampuan ekstraksi fitur otomatis. Fokus utama dalam literatur terkini terletak pada optimasi arsitektur *Convolutional Neural Networks* (CNN) untuk data spasial dan *Recurrent Neural Networks* (RNN) untuk data temporal (sekuensial).

### **2. Deep Learning dan Arsitektur CNN**
*Convolutional Neural Networks* (CNN) tetap menjadi standar emas dalam pengolahan data citra dan pola spasial. Jurnal-jurnal terbaru (2024-2025) menunjukkan pergeseran dari arsitektur *shallow* ke arsitektur yang lebih efisien seperti *ResNet* dan *EfficientNet* yang dimodifikasi. Keunggulan utama CNN terletak pada lapisan konvolusi yang mampu mereduksi dimensi data tanpa kehilangan informasi struktural penting. Penelitian pada tahun 2025 menunjukkan bahwa CNN memberikan presisi yang lebih tinggi dibandingkan model tradisional dalam menangkap fitur lokal pada dataset yang tidak seimbang.

### **3. Recurrent Neural Networks (RNN) dan Varian LSTM**
Untuk data deret waktu (*time-series*) dan teks, RNN tetap relevan, terutama melalui variannya seperti *Long Short-Term Memory* (LSTM) dan *Gated Recurrent Units* (GRU). Masalah klasik *vanishing gradient* pada RNN standar kini banyak diatasi dengan mekanisme *attention*. Literatur tahun 2025 mencatat efektivitas LSTM dalam prediksi kemampuan pemecahan masalah dan fluktuasi ekonomi karena kemampuannya mempertahankan memori jangka panjang dalam data sekuensial.

### **4. Sinergi Model Hybrid (CNN-RNN)**
Tren riset tahun 2025-2026 menunjukkan peningkatan penggunaan model **Hybrid CNN-RNN**. Arsitektur ini memanfaatkan CNN untuk mengekstraksi fitur dominan lokal (reduksi dimensi) yang kemudian diteruskan ke RNN untuk menangkap korelasi semantik temporal. Model hybrid ini terbukti mengungguli model tunggal dalam akurasi, presisi, dan stabilitas proses pembelajaran pada domain sinyal medis dan sistem keamanan IoT.

---

### **Perbedaan Machine Learning vs. Deep Learning**

Sebelum menarik kesimpulan, penting untuk memahami perbedaan fundamental antara *Machine Learning* (ML) konvensional dengan *Deep Learning* (DL):



| Karakteristik | Machine Learning (Tradisional) | Deep Learning |
| :--- | :--- | :--- |
| **Ekstraksi Fitur** | Memerlukan intervensi manusia secara manual (*Feature Engineering*). | Fitur diekstraksi secara otomatis melalui lapisan *neural network*. |
| **Volume Data** | Performa optimal pada dataset skala kecil hingga menengah. | Membutuhkan dataset skala besar (*Big Data*) untuk mencapai akurasi tinggi. |
| **Kebutuhan Perangkat** | Bisa berjalan pada CPU standar. | Memerlukan komputasi tinggi (GPU/TPU) karena banyaknya parameter. |
| **Interpretabilitas** | Cenderung lebih mudah diinterpretasikan (seperti *Decision Tree*). | Sering dianggap sebagai "*black box*" karena kompleksitas lapisannya. |
| **Struktur Data** | Bekerja sangat baik pada data terstruktur (tabel). | Unggul dalam mengolah data tidak terstruktur (citra, suara, video). |

---

### **5. Kesimpulan**
Evolusi *Deep Learning* dalam lima tahun terakhir menunjukkan transisi menuju model yang lebih cerdas dan integratif. CNN tetap tak tergantikan untuk fitur spasial, sementara RNN/LSTM mendominasi aspek temporal. Penggabungan keduanya dalam model hybrid menjadi solusi paling menjanjikan untuk menangani kompleksitas data di masa depan.

---

### **Daftar Pustaka**

* Sinaga, S. J., Gultom, S., Manurung, R., & Togatorop, P. D. (2025). Implementasi Deep Learning Berbasis Recurrent Neural Network (RNN) untuk Memprediksi Kemampuan Pemecahan Masalah Matematis Siswa. *Al-Irsyad Journal of Mathematics Education*, 5(1), 182-193. DOI: [10.58917/ijme.v5i1.522](https://doi.org/10.58917/ijme.v5i1.522)
* Ningrum, A. A., Syarif, I., Gunawan, A. I., Satriyanto, E., & Muchtar, R. (2021). Algoritma Deep Learning-LSTM untuk Memprediksi Umur Transformator. *Jurnal Teknologi Informasi dan Ilmu Komputer*, 8(3), 539-548. DOI: [10.25126/jtiik.2021834587](https://doi.org/10.25126/jtiik.2021834587)
* Sultan, H. (2024). Perbandingan Kinerja Algoritma Convolutional Neural Network (CNN) dan Recurrent Neural Network (RNN) pada Analisis Sentimen Pemilu. *Jurnal Pendidikan dan Teknologi Indonesia*, 4(2). DOI: [10.52436/1.jpti.652](https://doi.org/10.52436/1.jpti.652)
* Al-Sarem, M., et al. (2024). Deep Learning (CNN, RNN) Applications for Smart Homes: A Systematic Review. *Information*, 15(12). DOI: [10.3390/info15120755](https://doi.org/10.3390/info15120755)
* Zulfa, I. (2026). Analisis Kinerja Algoritma Deep Learning pada Pengolahan Data Kompleks. *ResearchGate Preprint*. DOI: [10.13140/RG.2.2.14004.12022](https://doi.org/10.13140/RG.2.2.14004.12022)
