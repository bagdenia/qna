class Comment< ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :user, :commentable, :commentable_type, :body, presence: true



  private

end
