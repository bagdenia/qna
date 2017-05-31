class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  default_scope { order(:id) }

  validates :body, :question_id, presence: true
end
