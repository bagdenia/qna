class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.map{|sub| sub.user}.each do |user|
      if answer.user != user
        AnswerMailer.informer(answer, user).deliver_now
      end
    end
    # Do something later
  end
end
