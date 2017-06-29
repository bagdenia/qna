json.extract! question, :id, :title, :user_id, :rating

json.attachments question.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
end
