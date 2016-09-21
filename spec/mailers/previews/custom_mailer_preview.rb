# Preview all emails at http://localhost:3000/rails/mailers/custom_mailer
class CustomMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/custom_mailer/digest
  def digest
    CustomMailer.digest
  end

  # Preview this email at http://localhost:3000/rails/mailers/custom_mailer/answer
  def answer
    CustomMailer.answer
  end

end
