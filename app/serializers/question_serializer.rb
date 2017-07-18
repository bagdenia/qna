class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at
  include CommentableSerializer
  include AttachmentableSerializer
end
