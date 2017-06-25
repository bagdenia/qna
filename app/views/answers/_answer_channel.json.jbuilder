json.extract! answer, :id, :body, :question, :user_id, :rating, :best
json.question_user_id answer.question.user_id
json.vote_up_path polymorphic_path([answer, :votes ], vote: { elect: 1})
json.vote_down_path polymorphic_path([answer, :votes ], vote: { elect: -1})
json.set_best_path set_best_answer_path(answer)
json.answer_path answer_path(answer)

json.attachments answer.attachments do |a|
  json.id a.id
  json.file_name a.file.identifier
  json.file_url a.file.url
end
