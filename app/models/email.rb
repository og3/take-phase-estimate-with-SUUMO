class Email < ApplicationRecord
  has_many :mitumori_logs

  def self.find_or_create_email(mail)
    Email.find_or_create_by(email: mail)
  end

  def sent_before?(url)
    mitumori_logs.select { |log| log.url == url }.present?
  end
end
