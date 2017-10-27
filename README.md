# GO-FOOD

Go-Food is a simplified Web Apps based on Ruby on Rails. In This Web Apps will show the items of food and you can order it like Go-Food in Go-Jek Corp.


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.


## What you need
* Ruby version 2.4.2


### Installing

Install rails

```
$ gem install rails
```

check versi rails yang terinstall (rails 5.)

```
$ rails -v
```


## Running the apps

Pertama, create the project with command 'rails new <app-name>'

```
$ rails new go-food
```

Kemudian, masuk ke direktori go-food dan jalankan server rails

```
$ cd go-food
$ rails server
```

Jika server berhasil dijalankan, kamu bisa cek di browser dengan port 3000 ```localhost:3000``` dan akan menampilkan landing page rails
Namun jika server gagal dijalankan, kamu perlu mengedit file Gemfile di baris ke 20 ``` # gem 'therubyracer', platforms: :ruby ``` hilangkan comment (hastag) kemudian jalankan perintah install di terminal dan jalankan kembali server

```
$ bundle install
$ rails server
```


## Generate MVC (Model, View, and Controller)

kamu bisa mengenerate MVC dengan perintah rails generate atau rails g dan cek perubahan/penambahan file apa saja yang digenerate menggunakan perintah git status

```
$ rails generate Controller Home hello
$ git status
```
