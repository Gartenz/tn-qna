require 'rails_helper'

RSpec.describe Vote, type: :model do
  subject { create(:vote, :for_question) }
  
  it { should belong_to :user }
  it { should belong_to :votable }

  it { should validate_presence_of :votable }
  it { should validate_uniqueness_of :user_id }
end
