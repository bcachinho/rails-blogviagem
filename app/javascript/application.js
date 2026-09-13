// app/javascript/application.js
import "@hotwired/turbo-rails"
import "controllers"
import "trix"
import "@rails/actiontext"
import "trix_alignment"   // << agora direto, sem ./ e sem application/
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()
