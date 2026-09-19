class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "contato@maishumblogdeviagem.com.br")
  layout "mailer"
end
