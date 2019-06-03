# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = User.create([ { email: 'testuser1@test.ru', admin: true, confirmed_at: Time.zone.now, password: '111111', password_confirmation: '111111' },
                      { email: 'testuser2@test.ru', confirmed_at: Time.zone.now, password: '111111', password_confirmation: '111111' }])

questions = []
5.times do |i|
  questions << Question.create(title: "Question #{i + 1}", body: 'Some question body', user: users[rand(0..1)] )
end

answers = []
5.times do
  answers << Answer.create(body: 'Some answer body',question: questions[rand(0..4)], user: users[rand(0..1)] )
end

types = [questions, answers]
comments = []
5.times do
  comments << Comment.create(body: 'some awesome comment', commentable: types[rand(0..1)][rand(0..4)], user: users[rand(0..1)] )
end
