class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user, :votable, :votable_type, presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validates :elect, inclusion: [1, -1]

  before_create :update_votable_rating
  before_destroy :update_votable_rating


  private

    def update_votable_rating
      klass = votable_type.constantize
      if (elect==1) == new_record?
        klass.increment_counter(:rating, votable_id)
      else
        klass.decrement_counter(:rating, votable_id)
      end
    end
end
