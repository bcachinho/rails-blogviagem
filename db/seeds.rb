# db/seeds.rb
admins = [
  { email: "bruno.cachinho@gmail.com", name: "Administrador", password: "senha_forte_do_primeiro_admin" },
  { email: "renato.viagista@gmail.com", name: "Administrador", password: "senha_forte_do_segundo_admin" }
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
