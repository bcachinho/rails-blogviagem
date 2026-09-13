class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "bruno.cachinho@gmail.com")
  layout "mailer"
end
