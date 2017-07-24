class Question < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable
  include Subscribable

  belongs_to :user
  has_many :answers, dependent: :destroy

  default_scope { order(:id) }

  validates :title, :body, presence: true
end
