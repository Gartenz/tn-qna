json.extract! answer, :id, :body, :score, :user_id, :best
json.question_user_id answer.question.user_id
json.vote_up_path polymorphic_path(answer, action: :vote_up)
json.vote_down_path polymorphic_path(answer, action: :vote_down)
json.vote_cancel_path polymorphic_path(answer, action: :vote_cancel)
json.set_best_path best_answer_path(answer)
json.answer_path answer_path(answer)

json.files answer.files do |a|
  json.name a.filename
  json.url url_for(a)
end

json.links answer.links do |a|
  if (is_gist?(a))
    json.is_gist true
    json. gist_files get_gist_files(a) do |f|
      json.name f[1].filename
      json.body f[1].content
    end
  else
    json.name a.name
    json.url a.url
  end
end
