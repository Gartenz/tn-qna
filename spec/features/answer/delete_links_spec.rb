require 'rails_helper'

feature 'User can delete links to existed answer', %q{
  In order to not confuse other users
  I'd like to be able to delete links from my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, question: question, user: user) }
  given(:simple_url) { 'https://google.com' }

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'delete link', js:true do
      within "div[data-answer-id='#{answer.id}']" do
        click_on 'Edit'

        nested_groups = all('div.nested-fields')

        within nested_groups.last do
          click_on 'remove link'
        end

        last_link = answer.links.last
        expect(page).to have_link last_link.name, href: last_link.url
        click_on 'Update'

        expect(page).to_not have_link last_link.name, href: last_link.url
      end
    end
  end
end
