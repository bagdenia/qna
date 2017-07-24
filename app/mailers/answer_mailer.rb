class AnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.informer.subject
  #
  def informer(answer, user)
    @greeting = "You've got new answer: "
    @answer = answer
    mail to: user.email
  end
end
