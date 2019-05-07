json.extract! answer, :id, :body, :question, :score, :user_id, :best
json.question_user_id answer.question.user_id
json.vote_up_path polymorphic_path(answer, action: :vote_up)
json.vote_down_path polymorphic_path(answer, action: :vote_down)
json.vote_cancel_path polymorphic_path(answer, action: :vote_cancel)
json.set_best_path best_answer_path(answer)
json.answer_path answer_path(answer)

json.attachments answer.files do |a|
  json.file_name a.file.identifier
  json.file_url a.file.url
end
