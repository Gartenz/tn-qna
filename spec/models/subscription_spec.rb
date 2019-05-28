require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { create(:subscription, :for_question) }

  it { should belong_to :user }
  it { should belong_to :subscribable }

  it { should validate_uniqueness_of(:user_id).scoped_to(:subscribable_type, :subscribable_id) }
end
