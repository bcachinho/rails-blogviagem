# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# ActionText e Trix
pin "trix" # @2.1.15
pin "@rails/actiontext", to: "actiontext.js"
pin "@rails/activestorage", to: "@rails--activestorage.js" # @8.0.201

# Arquivo customizado para alinhamento do Trix
pin "trix_alignment", to: "trix_alignment.js"
