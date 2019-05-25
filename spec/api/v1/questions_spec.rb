require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { {access_token: access_token.token} }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:list_response) { json['questions'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Listable' do
        let(:list) { questions }
        let(:fields) { %w[id title body created_at updated_at] }
      end

      it 'contains user object' do
        expect(list_response.first['user']['id']).to eq question.user.id
      end
    end
  end

  #включает в себя список комментариев, список прикрепленных файлов в виде url и список прикрепленных ссылок
  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question_with_all_appends) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }

      it 'returns nil if question does not exists' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response['body']).to be_nil
      end

      context 'question exists' do
        before { get api_path, params: { id: question.id, access_token: access_token.token }, headers: headers }

        it 'returns public fields' do
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq question.send(attr).as_json
          end
        end

        it 'contains user object' do
          expect(question_response['user']['id']).to eq question.user.id
        end

        context 'links' do
          it_behaves_like 'API Listable' do
            let(:list_response) { question_response['links'] }
            let(:list) { question.links }
            let(:fields) { %w[id name url] }
          end
        end

        context 'files' do
          let(:file_response) { question_response['files'].first }
          let(:file) { question.files.first }

          it 'returns list of files' do
            expect(question_response['files'].size).to eq 1
          end

          it 'returns  public fields' do
            expect(file_response['id']).to eq file.id
            expect(file_response['filename']).to eq file.filename.to_s
            expect(file_response['url']).to eq url_for(file)
          end
        end

        context 'comments' do
          let(:comment_response) { question_response['comments'].first }
          let(:comment) { question.comments.first }

          it_behaves_like 'API Listable' do
            let(:list_response) { question_response['comments'] }
            let(:list) { question.comments }
            let(:fields) { %w[id body user_id] }
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:params) { { question: attributes_for(:question), access_token: access_token.token } }
      let(:headers) { nil }
    end

    context 'authorized' do
      it 'creates new question' do
        expect { post api_path, params: { question: attributes_for(:question), access_token: access_token.token }}.to change(Question, :count).by(1)
      end

      it 'return Bad Request if no question params sended' do
        post api_path, params: { access_token: access_token.token }

        expect(response.status).to eq 400
      end

      it 'return Bad Request if bad question params sended' do
        bad_params = { 'titdle': '12312', 'bodt': '123123' }
        post api_path, params: { question: bad_params, access_token: access_token.token }

        expect(response.status).to eq 400
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:params) { { question: attributes_for(:question), access_token: access_token.token } }
      let(:headers) { nil }
    end

    context 'authorized' do
      it 'creates new question' do
        new_params = {
          title: "New Title",
        }
        patch api_path, params: { question: new_params, access_token: access_token.token }
        question.reload

        expect(question.title).to eq new_params[:title]
      end

      it 'return Bad Request if no question params sended' do
        patch api_path, params: { access_token: access_token.token }
        expect(response.status).to eq 400
      end

      it 'return Bad Request if bad question params sended' do
        bad_params = { 'titdle': '12312', 'bodt': '123123' }
        patch api_path, params: { question: bad_params, access_token: access_token.token }

        expect(question.title).to_not eq bad_params[:titdle]
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:params) { { access_token: access_token.token } }
      let(:headers) { nil }
    end

    context 'authorized' do
      it 'deletes question' do
        expect { delete api_path, params: { access_token: access_token.token } }.to change(Question, :count).by(-1)
      end

      it 'return Bad Request if no question found' do
        bad_path = "/api/v1/questions/-1"
        delete bad_path, params: { access_token: access_token.token }

        expect(response.status).to eq 400
      end
    end
  end
end
