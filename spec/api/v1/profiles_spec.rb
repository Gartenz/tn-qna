require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'reuturns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq user.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user'][attr]).to_not eq user.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 2) }
      let(:users_response) { json['users'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'reuturns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of other users' do
        expect(users_response.size).to eq 2
      end

      it 'does not returns current user' do
        users_response.each do |user_response|
          expect(user_response['id']).to_not eq user.id
        end
      end
    end
  end
end
