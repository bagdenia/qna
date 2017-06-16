class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def voted_this(item)
    votes.where('votable_type = ? and votable_id = ?', item.class.name, item.id).size > 0
  end

  def find_vote(item)
    votes.where('votable_type = ? and votable_id = ?', item.class.name, item.id).first
  end
end
