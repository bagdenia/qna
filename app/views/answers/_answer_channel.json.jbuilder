json.extract! answer, :id, :body, :question_id, :user_id, :rating, :best
json.question_user_id answer.question.user_id
json.attachments answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
end
