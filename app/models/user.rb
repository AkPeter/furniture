class User < ActiveRecord::Base
  before_validation :phone_normalize

  has_secure_password

  validates :name,  presence: true
  validates :phone, presence: true, uniqueness: true, format: {with: /\d{10}/, message: 'введите 10 цифр телефонного номера'}
  validates :email, presence: true, uniqueness: true, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create, message: 'введите настоящий адрес электронной почты'}

  def phone_normalize
    self.phone = phone.gsub(/^\+7|[\+\s\(\)\-]/, '')
  end

end