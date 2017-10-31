# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Food.delete_all

Food.create!(
  name: 'Mie Aceh',
  description:
    %{<p>
      Mie Aceh ini adalah salah satu kuliner primadona dari Aceh.
      Kepopuleran mie Aceh ini bahkan sudah sampai di kancah Internasional lho!
      Mie Aceh ini memang punya ciri khas dan cita rasa yang unik, enak dan tiada duanya.
      Hal ini dikarenakan bumbu yang digunakan untuk memasak ini penuh dengan rempah-rempah.
    </p>},
  image_url: 'mie_aceh.jpeg',
  price: 30000.0
)

Food.create!(
  name: 'Ayam Tangkap',
  description:
    %{<p>
      Ayam tangkap ini merupakan hidangan khas spesial dari daerah Aceh Besar.
      Ayam Tangkap adalah masakan dengan bahan utama ayam yang telah dipotong-potong
      lalu dimasak bersama cabe hijau, daun pandan, dan daun kari/daun teumuru.
    </p>},
  image_url: 'ayam_tangkap.jpeg',
  price: 35000.0
)

Food.create!(
  name: 'Sate Matang',
  description:
    %{<p>
      Sate ini dinamakan sate matang karena berasal dari daerah Matang di Kabupaten Bireuen Aceh.
      Sate Matang ini tidak seperti sate pada umumnya yang dibakar
      lalu diberi bumbu kecap dan saus kacang, lho.
      Sate matang justru disajikan dengan cara disiram dengan kuah soto yang gurih.
    </p>},
  image_url: 'sate_matang.jpeg',
  price: 20000.0
)

Buyer.delete_all

Buyer.create!(
  email: 'nurratnasarii@gmail.com',
  phone: '085277206510',
  address: 'Banda Aceh'
)

Buyer.create!(
  email: 'qurin@gmail.com',
  phone: '085277206220',
  address: 'Surabaya'
)

Buyer.create!(
  email: 'ajeng@gmail.com',
  phone: '085277206220',
  address: 'Bekasi'
)

Categories.delete_all

Categories.create!(
  name: 'Indonesian Food'
)

Categories.create!(
  name: 'Japanese Food'
)
