# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.new(
  email:"vuducvi20@gmail.com",
  username:"Admin",
  password: "anhvipandan",
  password_confirmation: "anhvipandan",
  role: User::ROLES[:admin],
  confirmed_at: DateTime.now
).save