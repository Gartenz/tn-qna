require 'rails_helper'

feature 'User can delete links to existed question', %q{
  In order to not confuse other users
  I'd like to be able to delete links from my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_links, user: user ) }

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'delete link', js:true do
      last_link = question.links.last

      within ".question-body" do
        expect(page).to have_link last_link.name, href: last_link.url
        click_on 'Edit'
      end

      within ".question-form" do
        nested_groups = all('div.nested-fields')

          within nested_groups.last do
            click_on 'remove link'
          end

        click_on 'Update'
      end

      expect(page).to_not have_link last_link.name, href: last_link.url
    end
  end
end
