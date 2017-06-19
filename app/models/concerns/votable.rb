module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end
  def voted_by?(user)
    votes.where(user: user).exists?
  end

  def find_vote(user)
    votes.where(user: user).first
  end

end
