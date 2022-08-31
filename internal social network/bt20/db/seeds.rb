# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
99.times do |index|
  name = Faker::Name.name      #=> "Christophe Bartell"
  email = Faker::Internet.email
  User.create(name: name, email: "thang_#{index}@gmail.com", password: '123', password_confirmation: '123',
              activated: true, activated_at: Time.zone.now)
end
