class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user, :question, presence: true
  validates :question_id, uniqueness: {scope: :user_id}

  # scope :with_admin_user,  lambda { joins(:user).where(users: {admin: true}) }
end
