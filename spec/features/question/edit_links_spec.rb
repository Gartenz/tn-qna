require 'rails_helper'

feature 'User can add links to existed answer', %q{
  In order to provide additioanal info to my answer
  I'd like to be able to add links
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:simple_url) { 'https://google.com' }

  describe 'Authenticated user as author', js: true do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'adds links', js:true do
      within ".question-body" do
        click_on 'Edit'
      end

      within ".question-form" do
        click_on 'add link'
        
        nested_groups = all('div.nested-fields')

        within nested_groups.last do
          fill_in 'Link name', with: 'Simple url'
          fill_in 'Url', with: simple_url
        end

        click_on 'Update'
      end

      expect(page).to have_link 'Simple url', href: simple_url
    end
  end
end
