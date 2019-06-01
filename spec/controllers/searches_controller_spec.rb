require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "POST #search" do
    let(:params) { { search_type: "", search_string: "" } }
    let(:service) { double('Services::Search') }

    before do
      expect(Services::Search).to receive(:new).and_return(service)
    end

    it 'calls Services::Search#search' do
      expect(service).to receive(:search).with(params)
      get :search, params: { search: params }
    end
  end
end
