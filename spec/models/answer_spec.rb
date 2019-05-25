require 'rails_helper'
require_relative 'concerns/votable_spec'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question }

  describe Answer do
    it_behaves_like "votable"
    it_behaves_like "Model linkable"
    it_behaves_like "Model filable"
  end
end
