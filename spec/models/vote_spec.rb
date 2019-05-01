require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }

  it { should validate_inclusion_of(:good).in_array([true, false]) }
end
