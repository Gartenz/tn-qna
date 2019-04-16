require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#validates_url_format' do
    it 'expects to create object' do
      expect { create(:link) }.to change(Link, :count).by(1)
    end

    it 'false if url is invalid' do
      expect { create(:link, :with_invalid_link) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
