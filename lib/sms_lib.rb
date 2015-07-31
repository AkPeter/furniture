module SmsLib

  def sms_new_bee(user, password)
    message = "твой пароль на #{ApplicationController::Domain} #{password}"
    send_sms user.phone, message
  end

  private

  def send_sms(recepient_10dgt, message)
    require 'russland_sms'

    message.to_s.sms recepient_10dgt
  end

end