class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable
  default_scope { order({ best: :desc }, :id) }

  validates :body, :question_id, presence: true

  accepts_nested_attributes_for :attachments
  def set_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
