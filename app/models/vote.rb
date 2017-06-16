class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, :votable, :votable_type, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :elect, inclusion: [false, true]
  validate :self_vote_denied

  before_create :update_votable_rating
  before_destroy :update_votable_rating


  private

    def update_votable_rating
      klass = Class.const_get(votable_type)
      if elect? == new_record?
        klass.increment_counter(:rating, votable_id)
      else
        klass.decrement_counter(:rating, votable_id)
      end
    end

    def self_vote_denied
      if votable.user_id == user_id
        errors.add(:user, 'You cant vote for his ' + votable_type)
      end
    end





end
