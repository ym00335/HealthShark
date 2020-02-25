# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview for a mail
  def new_mail
    # Get the last mail from the database and use it to create a mail
    mail = SentMail.last
    ContactMailer.contact_email(mail.email, mail.name, mail.telephone, mail.title, mail.message)
  end
end
