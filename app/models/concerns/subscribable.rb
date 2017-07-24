module Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy
    after_create :subscribe_author
  end

  def subscribed_by?(user)
    subscriptions.where(user: user).exists?
  end

  def find_subscription(user)
    subscriptions.where(user: user).first
  end

  def subscribe_author
    Subscription.create!(user: user, question: self)
  end

end
