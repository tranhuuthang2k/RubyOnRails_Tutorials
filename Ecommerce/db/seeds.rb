# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

City.create([
              { name: 'Da nang' },
              { name: 'Hue' },
              { name: 'Can tho' }
            ])
Shipping.create(
  [
    { name: 'viettel post', description: 'received for 3-5 days', price: 30 },
    { name: 'giao hang tiet kiem', description: 'received for 2-3 days', price: 50 }
  ]
)

Brand.create!([
                { id: 1, name: 'NIKE' },
                { id: 2, name: 'T-SHIRT' },
                { id: 3, name: 'ADDIDASS' },
                { id: 4, name: 'SPEAKER' },
                { id: 5, name: 'JEAN' },
                { id: 6, name: 'TAY AU' }
              ])

User.create!([
               { email: 'testadmin@mvmanor.co.uk', username: 'test', mobile: '12345678910', city_id: 1, gender: 'female',
                 encrypted_password: '#$taawktljasktlw4aaglj', password: 'Thang%%%123', password_confirmation: 'Thang%%%123', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, admin: true },
               { email: 'testuser@mvmanor.co.uk', username: 'test', mobile: '12345678910', city_id: 2, gender: 'female',
                 encrypted_password: '#$taawktljasktlw4aaglj', password: 'Thang%%%123', password_confirmation: 'Thang%%%123', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, admin: false },
               { email: 'testcustomer@customer.co.uk', username: 'test', mobile: '12345678910', city_id: 1, gender: 'female',
                 encrypted_password: '#$taawktljasktlw4aaglj', password: 'Thang%%%123', password_confirmation: 'Thang%%%123', reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, admin: false }
             ])

Category.create!([
                   { name: 'quan tay' },
                   { name: 'quan tay1', categories_id: 1 },
                   { name: 'quan tay2', categories_id: 1 },
                   { name: 'quan tay3', categories_id: 1 },
                   { name: 'quan Trend' },
                   { name: 'quan Trend1', categories_id: 5 },
                   { name: 'quan Trend2', categories_id: 5 },
                   { name: 'quan Trend3', categories_id: 5 },
                   { name: 'quan MY' },
                   { name: 'Nile' },
                   { name: 'addidas', categories_id: 10 }
                 ])

Availability.create!([
                       { name: 'Availability_name1', status: '1', number_product: 30 },
                       { name: 'Availability_name2', status: '0', number_product: 20 },
                       { name: 'Availability_name3', status: '1', number_product: 10 }
                     ])

Product.create!([
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1,
                    user_id: 1, categories_id: 1 },
                  { title: 'quan jean', price: '50', description: 'Hang VN', brand_id: 5, show_home: 2, availability_id: 1,
                    user_id: 2, categories_id: 1 },
                  { title: 'quan tay au', price: '50', description: 'Hang VN', brand_id: 6, show_home: 2, availability_id: 2, user_id: 2,
                    categories_id: 1 },
                  { title: 'giay nike ', price: '50', description: 'Hang VN', brand_id: 1, show_home: 1, availability_id: 3,
                    user_id: 1, categories_id: 1 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 2 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 3 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 4 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 5 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 7 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 8 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 9 },
                  { title: 'ao so mi', price: '50', description: 'Hang VN', brand_id: 2, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 10 },
                  { title: 'Aoi Speak', price: '50', description: 'Hang VN', brand_id: 4, show_home: 1, availability_id: 1,
                    user_id: 1, categories_id: 2 },
                  { title: 'shoes', price: '50', description: 'Hang VN', brand_id: 3, show_home: 1, availability_id: 1, user_id: 1,
                    categories_id: 2 }
                ])

ProductCategory.create([
                         { product_id: 1, category_id: 2 },
                         { product_id: 2, category_id: 2 },
                         { product_id: 3, category_id: 2 },
                         { product_id: 3, category_id: 1 },
                         { product_id: 1, category_id: 2 }
                       ])
Size.create([
              { name: 'XL' },
              { name: 'S' },
              { name: 'L' }
            ])
