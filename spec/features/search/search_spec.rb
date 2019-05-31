require 'sphinx_helper'
# require 'rails_helper'

feature 'Everybody can search by some criteria', %q{
  In order to find some usefull information
  Visitors can use search to find
  Users, Questions, Answers and Comments
} do
  given!(:users) { create_list(:user, 2) }
  given!(:questions) { create_list(:question, 3, user: users.first) }
  given!(:answers) { create_list(:answer, 3, question: questions.first, user: users.last) }
  given!(:comments) { create_list(:comment, 2, commentable: questions .last) }

  background do
    visit root_path
  end

  describe 'Search in all items', sphinx: true, js:true do
    scenario 'with empty search string' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        users.each { |u| expect(page).to have_content u.email }
        questions.each { |q| expect(page).to have_content q.title }
        answers.each { |a| expect(page).to have_content a.body }
        comments.each { |c| expect(page).to have_content c.body }
      end
    end

    scenario 'with specific search string' do
      fill_in :search, with: "#{users.last.email}"
    ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content users.last.email
        expect(page).to_not have_content users.first.email
        expect(page).to_not have_content 'MyText'
        answers.each { |a| expect(page).to have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end
  end

  describe 'Search only in questions', sphinx: true, js:true do
    background do
      select('Questions', from: 'search_type')
    end

    scenario 'lists only questions' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        users.each { |u| expect(page).to_not have_content u.email }
        answers.each { |a| expect(page).to_not have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end

    scenario 'with empty search string' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        questions.each { |q| expect(page).to have_content q.title }
      end
    end

    scenario 'Serch particular question', sphinx: true, js:true do
      fill_in :search, with: questions.first.title
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content questions.first.title
        questions[1..-1].each { |q| expect(page).to_not have_content q.title }
      end
    end
  end

  describe 'Search only in answers', sphinx: true, js:true do
    background do
      select('Answers', from: 'search_type')
    end

    scenario 'lists only answers' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        users.each { |u| expect(page).to_not have_content u.email }
        expect(page).to_not have_content 'MyText'
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end

    scenario 'with empty search string' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        answers.each { |a| expect(page).to have_content a.body }
      end
    end

    scenario 'Serch particular answer', sphinx: true, js:true do
      fill_in :search, with: answers.first.body
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content answers.first.body
        answers[1..-1].each { |a| expect(page).to_not have_content a.body }
      end
    end
  end

  describe 'Search only in comments', sphinx: true, js:true do
    background do
      select('Comments', from: 'search_type')
    end

    scenario 'lists only comments' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        users.each { |u| expect(page).to_not have_content u.email }
        expect(page).to_not have_content 'MyText'
        answers.each { |a| expect(page).to_not have_content a.body }
      end
    end

    scenario 'Serch particular comment', sphinx: true, js:true do
      fill_in :search, with: comments.first.body
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content comments.first.body
        expect(page).to_not have_content comments.last.body
      end
    end
  end

  describe 'Search only in users', sphinx: true, js:true do
    background do
      select('Users', from: 'search_type')
    end

    scenario 'lists only comments' do
      ThinkingSphinx::Test.run do
        click_on 'Search'

        questions.each { |q| expect(page).to_not have_content q.title }
        answers.each { |a| expect(page).to_not have_content a.body }
        comments.each { |c| expect(page).to_not have_content c.body }
      end
    end

    scenario 'Serch particular comment', sphinx: true, js:true do
      fill_in :search, with: users.first.email
      ThinkingSphinx::Test.run do
        click_on 'Search'

        expect(page).to have_content users.first.email
        expect(page).to_not have_content users.last.email
      end
    end
  end
end
