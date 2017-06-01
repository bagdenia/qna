class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  default_scope { order({ best: :desc }, :id) }

  validates :body, :question_id, presence: true

  def set_best
    question.answers.update_all(best: false)
    update(best: true)
  end
end
