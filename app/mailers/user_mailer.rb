class UserMailer < ApplicationMailer
  include SmsLib

  def admins_mail
    User.where(admin:true).pluck(:email)
  end
  helper_method :admins_mail

  def new_bee(user, password)
    @username = user.name
    @signin  = ApplicationController::SignInURL
    @password = password

    sms_new_bee user, password if user.phone

    mail(to: user.email, subject: "С подключением на #{ApplicationController::Domain} !")
  end

  def password_reset(user, resurrection)
    @username = user.name
    require 'uri'
    @uri = URI "#{ApplicationController::SignInURL}/resurrection"
    params = {:resurrection_code => resurrection}
    @uri.query = URI.encode_www_form params
    p @uri

    # sms_password_reset user, new_password if user.phone

    mail(to: user.email, subject: "Инструкция по восстановлению пароля на #{ApplicationController::Domain}")
  end

end