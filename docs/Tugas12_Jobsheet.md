# Sistem Rekomendasi Destinasi Wisata Kota Bandung Berbasis Collaborative Filtering

## Pendahuluan

Sebelum bepergian, biasanya seseorang akan membuat rencana terlebih dahulu tentang lokasi yang akan dikunjungi dan waktu keberangkatannya. Hal ini dilakukan untuk perencanaan sebelum berwisata ke suatu Kota.

Kota Bandung memiliki daya tarik wisata yang cukup tinggi, namun dikutip dari humas.bandung.go.id/ jumlah wisatawan ke Kota Bandung turun 50% pada tahun 2021. Tentunya angka ini wajar karena penyebaran Covid-19 yang mengkhawatirkan di Indonesia.

Untuk periode Oktober 2021, sejumlah wisata di Kota Bandung sudah mulai beroperasi, ini akan menjadi momentum yang tepat untuk menggerakkan pariwisata kembali.

Pada projek ini, saya akan membuat sebuah sistem rekomendasi berbasis collaborative filtering untuk menampilkan top-n recommendation destinasi wisata di Kota Bandung berdasarkan data user, rating, dan place.

## 1. Mengimpor Library Python yang Dibutuhkan

```python
# Untuk pengolahan data
import pandas as pd
import numpy as np
from zipfile import ZipFile
from pathlib import Path

# Untuk visualisasi data
import seaborn as sns
import matplotlib.pyplot as plt

%matplotlib inline
sns.set_palette('Set1')
sns.set()

# Untuk pemodelan
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

# Untuk menghilangkan warnings saat plotting seaborn
import warnings
warnings.filterwarnings('ignore')

# Untuk mengupload file
import os
```

**J.62DMI00.001.1 - Mengumpulkan Data**

## 2. Menyiapkan Dataset yang digunakan

```python
# Upload semua dataset yang dipakai
for dirname, _, filenames in os.walk('/content'):
    for filename in filenames:
        print(os.path.join(dirname, filename))
```

**Keterangan:**

*   `tourism_with_id.csv` - mengandung informasi tempat wisata di 5 kota besar di Indonesia (hanya kota Bandung yang dipakai)
*   `user.csv` - mengandung informasi pengguna untuk membuat rekomendasi fitur berdasar pengguna
*   `tourism_rating.csv` - mengandung informasi pengguna, tempat wisata, dan rating untuk membuat sistem rekomendasi berdasar rating

## 3. Data Understanding

### 3.1 Menyiapkan Data

```python
# Menyimpan masing-masing dataset kedalam variabel
rating = pd.read_csv('/content/tourism_rating.csv')
place = pd.read_csv('/content/tourism_with_id.csv')
user = pd.read_csv('/content/user.csv')
```

**J.62DMI00.010.1 - Menentukan Label Data**

```python
print(rating.columns)
print(place.columns)
print(user.columns)
```

### 3.2 Eksplorasi Fitur-fitur pada Data

#### 3.2.1. Data place

**J.62DMI00.007.1 - Menentukan Objek Data**

```python
# Melihat gambaran data place
place.head(2)
```

```python
# Membuang kolom yang tidak dipakai
place = place.drop(['Unnamed: 11', 'Unnamed: 12'], axis=1)
place.head(2)
```

```python
# Merubah data agar hanya dari Kota Bandung
place = place[place['City'] == 'Bandung']
place.head(2)
```

**J.62DMI00.005.1 - Menelaah Data**

```python
place.info()
```

**J.62DMI00.008.1 - Membersihkan Data**

```python
# Membuang kolom yang tidak dipakai lagi
place = place.drop('Time_Minutes', axis=1)
```

**J.62DMI00.006.1 - Memvalidasi Data**

```python
place.isnull().sum()
```

#### 3.2.2. Data rating

**J.62DMI00.007.1 - Menentukan Objek Data**

```python
# melihat gambaran data rating
rating.head()
```

**J.62DMI00.005.1 - Menelaah Data**

```python
rating.info()
```

**J.62DMI00.008.1 - Membersihkan Data**

```python
# Merubah data rating agar hanya berisi rating pada tempat wisata dari Kota Bandung
rating = pd.merge(rating, place[['Place_Id']], how='right', on='Place_Id')
rating.head()
```

**J.62DMI00.006.1 - Memvalidasi Data**

```python
# Melihat ukuran dataset rating untuk Kota Bandung
rating.shape
```

#### 3.2.3. Data user

**J.62DMI00.007.1 - Menentukan Objek Data**

```python
# Melihat gambaran data user
user.head()
```

**J.62DMI00.008.1 - Membersihkan Data**

```python
# Merubah data user agar hanya berisi user yang pernah mengunjungi wisata di Kota Bandung
user = pd.merge(user, rating[['User_Id']], how='right', on='User_Id').drop_duplicates()
user.head()
```

**J.62DMI00.006.1 - Memvalidasi Data**

```python
# Melihat dataset user yang pernah memberi rating pada wisata di Kota Bandung
user.shape
```

## 4. Eksplorasi Data

```python
# Membuat visualisasi jumlah kategori wisata di Kota Bandung
sns.countplot(y='Category', data=place)
plt.title('Perbandingan Jumlah Kategori Wisata di Kota Bandung', pad=20)
plt.show()
```

```python
# Membuat visualisasi distribusi usia user
plt.figure(figsize=(5,3))
sns.boxplot(user['Age'])
plt.title('Distribusi Usia User', pad=20)
plt.show()
```

```python
# Membuat visualisasi distribusi harga masuk tempat wisata
plt.figure(figsize=(7,3))
sns.boxplot(place['Price'])
plt.title('Distribusi Harga Masuk Wisata di Kota Bandung', pad=20)
plt.show()
```

```python
# Memfilter asal kota dari user
askot = user['Location'].apply(lambda x : x.split(',')[0])

# Visualisasi asal kota dari user
plt.figure(figsize=(8,6))
sns.countplot(y=askot)
plt.title('Jumlah Asal Kota dari User')
plt.show()
```

## 5. Persiapan Data untuk Pemodelan

**J.62DMI00.009.1 - Mengonstruksi Data**

### 5.1. Membuat Salinan Data rating

```python
# Membaca dataset untuk dilakukan encoding
df = rating.copy()
df.head()
```

### 5.2. Melakukan Encoding

#### 5.2.1. Membuat Fungsi untuk Melakukan Encoding

```python
def dict_encoder(col, data=df):
    # Mengubah kolom suatu dataframe menjadi list tanpa nilai yang sama
    unique_val = data[col].unique().tolist()
    
    # Melakukan encoding value kolom suatu dataframe ke angka
    val_to_val_encoded = {x: i for i, x in enumerate(unique_val)}
    
    # Melakukan proses encoding angka ke value dari kolom suatu dataframe
    val_encoded_to_val = {i: x for i, x in enumerate(unique_val)}
    return val_to_val_encoded, val_encoded_to_val
```

#### 5.2.2. Encoding dan Mapping Kolom User

```python
# Encoding User_Id
user_to_user_encoded, user_encoded_to_user = dict_encoder('User_Id')

# Mapping User_Id ke dataframe
df['user'] = df['User_Id'].map(user_to_user_encoded)
```

#### 5.2.3. Encoding dan Mapping Kolom Place

```python
# Encoding Place_Id
place_to_place_encoded, place_encoded_to_place = dict_encoder('Place_Id')

# Mapping Place_Id ke dataframe
df['place'] = df['Place_Id'].map(place_to_place_encoded)
```

### 5.3. Melihat Gambaran Data untuk Pemodelan

```python
# Mendapatkan jumlah user dan place
num_users, num_place = len(user_to_user_encoded), len(place_to_place_encoded)

# Mengubah rating menjadi nilai float
df['Place_Ratings'] = df['Place_Ratings'].values.astype(np.float32)

# Mendapatkan nilai minimum dan maksimum rating
min_rating, max_rating = min(df['Place_Ratings']), max(df['Place_Ratings'])

print(f'Number of User: {num_users}, Number of Place: {num_place}, Min Rating: {min_rating}, Max Rating: {max_rating}')
```

```python
# Mengacak dataset
df = df.sample(frac=1, random_state=42)
df.head(2)
```

## 6. Pemodelan Machine Learning dengan RecommenderNet

**J.62DMI00.013.1 - Membangun Model**

### 6.1. Membagi data train dan test

```python
# Membuat variabel x untuk mencocokkan data user dan place menjadi satu value
x = df[['user', 'place']].values

# Membuat variabel y untuk membuat rating dari hasil
y = df['Place_Ratings'].apply(lambda x: (x - min_rating) / (max_rating - min_rating)).values

# Membagi menjadi 80% data train dan 20% data validasi
train_indices = int(0.8 * df.shape[0])
x_train, x_val, y_train, y_val = (
    x[:train_indices],
    x[train_indices:],
    y[:train_indices],
    y[train_indices:]
)
```

### 6.2. Menyiapkan Model

#### 6.2.1. Inisialisasi Fungsi

```python
class RecommenderNet(tf.keras.Model):
    # Inisialisasi fungsi
    def __init__(self, num_users, num_places, embedding_size, **kwargs):
        super(RecommenderNet, self).__init__(**kwargs)
        self.num_users = num_users
        self.num_places = num_places
        self.embedding_size = embedding_size
        self.user_embedding = layers.Embedding( # Layer embedding user
            num_users,
            embedding_size,
            embeddings_initializer = 'he_normal',
            embeddings_regularizer = keras.regularizers.l2(1e-6)
        )
        self.user_bias = layers.Embedding(num_users, 1) # Layer embedding user bias
        self.places_embedding = layers.Embedding( # Layer embeddings places
            num_places,
            embedding_size,
            embeddings_initializer = 'he_normal',
            embeddings_regularizer = keras.regularizers.l2(1e-6)
        )
        self.places_bias = layers.Embedding(num_places, 1) # Layer embedding places bias

    def call(self, inputs):
        user_vector = self.user_embedding(inputs[:,0]) # memanggil layer embedding 1
        user_bias = self.user_bias(inputs[:, 0]) # memanggil layer embedding 2
        places_vector = self.places_embedding(inputs[:, 1]) # memanggil layer embedding 3
        places_bias = self.places_bias(inputs[:, 1]) # memanggil layer embedding 4
        
        dot_user_places = tf.tensordot(user_vector, places_vector, 2)
        
        x = dot_user_places + user_bias + places_bias
        
        return tf.nn.sigmoid(x) # activation sigmoid
```

#### 6.2.2. Inisialisasi Model

```python
model = RecommenderNet(num_users, num_place, 50) # inisialisasi model

# model compile
model.compile(
    loss = tf.keras.losses.BinaryCrossentropy(),
    optimizer = keras.optimizers.Adam(learning_rate=0.0004),
    metrics=[tf.keras.metrics.RootMeanSquaredError()]
)
```

#### 6.2.3. Inisialisasi Callbacks

```python
class myCallback(tf.keras.callbacks.Callback):
    def on_epoch_end(self, epoch, logs={}):
        if(logs.get('val_root_mean_squared_error')<0.25):
            print('Lapor! Metriks validasi sudah sesuai harapan')
            self.model.stop_training = True
```

#### 6.2.4. Proses Training

```python
# Memulai training
history = model.fit(
    x = x_train,
    y = y_train,
    epochs = 100,
    validation_data = (x_val, y_val),
    callbacks = [myCallback()]
)
```

**J.62DMI00.014.1 - Mengevaluasi Hasil Pemodelan**

```python
# Menampilkan plot loss dan validation
plt.plot(history.history['root_mean_squared_error'])
plt.plot(history.history['val_root_mean_squared_error'])
plt.title('model_metrics')
plt.ylabel('root_mean_squared_error')
plt.xlabel('epoch')
plt.ylim(ymin=0, ymax=0.4)
plt.legend(['train', 'test'], loc='center left')
plt.show()
```

## 7. Memprediksi Top 7 Rekomendasi

### 7.1 Menyiapkan DataFrame untuk Menampilkan Hasil Rekomendasi

```python
# Menyiapkan dataframe
place_df = place[['Place_Id', 'Place_Name', 'Category', 'Rating', 'Price']]
place_df.columns = ['id', 'place_name', 'category', 'rating', 'price']
df = rating.copy()
```

### 7.2. Menyiapkan contoh User untuk Menampilkan Rekomendasi

#### 7.2.1 Mencari User

```python
# Mengambil sample user
user_id = df.User_Id.sample(1).iloc[0]
place_visited_by_user = df[df.User_Id == user_id]
```

#### 7.2.2. Mencari Lokasi yang belum Dikunjungi User

```python
# Membuat data lokasi yang belum dikunjungi user
place_not_visited = place_df[~place_df['id'].isin(place_visited_by_user.Place_Id.values)]['id']
place_not_visited = list(
    set(place_not_visited)
    .intersection(set(place_to_place_encoded.keys()))
)

place_not_visited = [[place_to_place_encoded.get(x)] for x in place_not_visited]
user_encoder = user_to_user_encoded.get(user_id)
user_place_array = np.hstack(
    ([[user_encoder]] * len(place_not_visited), place_not_visited)
)
```

### 7.3. Menampilkan Hasil Rekomendasi untuk User

```python
# Mengambil top 7 recommendation
ratings = model.predict(user_place_array).flatten()
top_ratings_indices = ratings.argsort()[-7:][::-1]
recommended_place_ids = [
    place_encoded_to_place.get(place_not_visited[x][0]) for x in top_ratings_indices
]

print('Daftar rekomendasi untuk: {}'.format('User ' + str(user_id)))
print('===' * 15, '\n')
print('----' * 15)
print('Tempat dengan rating wisata paling tinggi dari user')
print('----' * 15)

top_place_user = (
    place_visited_by_user.sort_values(
        by = 'Place_Ratings',
        ascending=False
    )
    .head(5)
    .Place_Id.values
)

place_df_rows = place_df[place_df['id'].isin(top_place_user)]
for row in place_df_rows.itertuples():
    print(row.place_name, ':', row.category)

print('')
print('----' * 15)
print('Top 7 place recommendation')
print('----' * 15)

recommended_place = place_df[place_df['id'].isin(recommended_place_ids)]
for row, i in zip(recommended_place.itertuples(), range(1, 8)):
    print(i, '.', row.place_name, '\n', ' ', row.category, ',', 'Harga Tiket Masuk', ',', row.price, ',', 'Rating Wisata', row.rating)

print('==='*15)
```

## Penutup

Model untuk menampilkan top 7 rekomendasi tempat wisata telah selesai dibuat dan model ini dapat digunakan untuk menampilkan rekomendasi kepada user yang harapannya dapat meningkatkan jumlah wisatawan di Kota Bandung. Namun demikian beberapa pengembangan lain masih dapat dilakukan agar dapat membuat model yang menampilkan rekomendasi yang lebih sesuai dengan kebiasaan pengguna, dll.

## Referensi

*   Seaborn: https://seaborn.pydata.org/tutorial.html
*   Callback: https://www.tensorflow.org/api_docs/python/tf/keras/callbacks/Callback
*   Lainnya:
    *   https://github.com/AgungP88/getloc-apps/tree/machine-learning
    *   https://www.kaggle.com/ibtesama/getting-started-with-a-movie-recommendation-system
    *   https://www.dicoding.com/academies/319
```
