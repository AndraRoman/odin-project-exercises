class PassengerMailer < ApplicationMailer
  default from: 'flight-picker@example.com'

  def thank_you_email(passenger)
    @passenger = passenger
    mail(to: @passenger.email, subject: 'Thank you for flying with us!')
  end
end
