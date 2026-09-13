# db/seeds.rb
admins = [
  { email: "admin@blogdeviagem.com", name: "Administrador", password: ENV.fetch("ADMIN1_PASSWORD") },
  { email: "outra-pessoa@example.com", name: "Segundo Admin", password: ENV.fetch("ADMIN2_PASSWORD") }
]

admins.each do |data|
  admin = User.find_or_initialize_by(email: data[:email])
  admin.name = data[:name]
  admin.password = data[:password]
  admin.password_confirmation = data[:password]
  admin.role = :admin
  admin.skip_confirmation! if admin.respond_to?(:skip_confirmation!)
  admin.save!

  puts "Usuário admin '#{data[:email]}' criado/atualizado com sucesso!"
end
