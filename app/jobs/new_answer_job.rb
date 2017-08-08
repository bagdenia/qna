class NewAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscriptions.map{|sub| sub.user}.each do |user|
      if answer.user != user
        AnswerMailer.informer(answer, user).deliver_later #ну и они перестали отправляться с later, шеф все пропало
      end
    end
    # Do something later
  end
end
