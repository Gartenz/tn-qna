require 'rails_helper'

shared_examples_for 'Model filable' do
  let(:model) { described_class }

  it 'have many attached file' do
    expect(model.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
