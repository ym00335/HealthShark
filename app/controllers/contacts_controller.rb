class ContactsController < ApplicationController
  # Authenticate the user before each action.
  before_action :authenticate_user!


  def index
    # Create a new Mail to fill the forms with.
    @sent_mail = SentMail.new
  end

  # Send email
  # post http request to mail/send
  def send_mail
    # Create a new mail with the parameters from the post request
    @sent_mail = SentMail.new(mail_params)

    # Set the user of the mail to be the current user
    @sent_mail.user = current_user

    # Try to save the mail to the database
    if @sent_mail.save
      # Send the mail through the mailer
      ContactMailer.contact_email(mail_params[:email], mail_params[:name], mail_params[:telephone], mail_params[:title], mail_params[:message]).deliver_now

      # Redirect to the home index with an informative notice
      redirect_to home_index_path, notice: I18n.t('controllers.contacts.send_success')
    else
      # Render contacts/index again and alert the user for the error
      render :index, alert: I18n.t('controllers.contacts.send_fail')
    end
  end

  private

  # Specify parameters, which are allowed; do not trust the 'scary' internet
  def mail_params
    params.require(:sent_mail).permit(:name, :email, :telephone, :title, :message)
  end
end
