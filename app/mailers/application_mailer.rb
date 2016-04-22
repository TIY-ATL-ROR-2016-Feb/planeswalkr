class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@planeswalkr.herokuapp.com"
  layout 'mailer'
end
