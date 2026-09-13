# db/seeds.rb
User.create!(
  name: "Admin",
  email: "admin@blog.com",
  password: "123456",
  password_confirmation: "123456",
  role: 1,
  confirmed_at: Time.current # importante se estiver usando confirmable
)
