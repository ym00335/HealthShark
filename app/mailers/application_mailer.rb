class ApplicationMailer < ActionMailer::Base
  # set the defaults of the mail and its layout
  default to: 'info@mynotes.com', from: 'info@mynotes.com'
  layout 'mailer'
end
