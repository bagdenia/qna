class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at
  has_many :comments
  include CommentableSerializer
  include AttachmentableSerializer
end
