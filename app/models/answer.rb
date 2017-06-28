class Answer < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  default_scope { order({ best: :desc }, :id) }

  validates :body, :question_id, presence: true

  def set_best
    Answer.transaction do
      question.answers.where('id != ?', id).update_all(best: false)
      update!(best: ! best)
    end
  end
end
