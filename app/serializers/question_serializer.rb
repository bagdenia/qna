class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at
  include CommentableSer
  include AttachmentableSer
end
