require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let!(:user) { create(:user) }
  let!(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:question) { create(:question) }

  describe 'GET /api/v1/questions/:queston_id/answers' do
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { question_id: question.id, access_token: access_token.token } }
    end

    context 'authorized' do
      let(:answer) { answers.first }
      let(:list_response) { json['answers'] }

      before { get api_path, params: { question_id: question.id, access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Listable' do
        let(:list) { answers }
        let(:fields) { %w[id body created_at updated_at] }
      end

      it 'contains user object' do
        expect(list_response.first['user']['id']).to eq answer.user.id
      end
    end
  end

  #включает в себя список комментариев, список прикрепленных файлов в виде url и список прикрепленных ссылок
  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer_with_all_appends) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }

      it 'returns nil if answer does not exists' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response['body']).to be_nil
      end

      context 'answer exists' do
        before { get api_path, params: { id: answer.id, access_token: access_token.token }, headers: headers }

        it 'returns public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'contains user object' do
          expect(answer_response['user']['id']).to eq answer.user.id
        end

        context 'links' do
          it_behaves_like "API Listable" do
            let(:list_response) { answer_response['links'] }
            let(:list) { answer.links }
            let(:fields) { %w[id name url] }
          end
        end

        context 'files' do
          let(:file_response) { answer_response['files'].first }
          let(:file) { answer.files.first }

          it 'returns list of files' do
            expect(answer_response['files'].size).to eq 1
          end

          it 'returns  public fields' do
            expect(file_response['id']).to eq file.id
            expect(file_response['filename']).to eq file.filename.to_s
            expect(file_response['url']).to eq url_for(file)
          end
        end

        context 'comments' do
          let(:comment_response) { answer_response['comments'].first }
          let(:comment) { answer.comments.first }

          it_behaves_like "API Listable" do
            let(:list_response) { answer_response['comments'] }
            let(:list) { answer.comments }
            let(:fields) { %w[id body user_id] }
          end
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:params) { { access_token: access_token.token } }
    end

    context 'authorized' do
      it 'creates new answer' do
        expect { post api_path, params: { question_id: question.id,  answer: attributes_for(:answer), access_token: access_token.token } }.to change(Answer, :count).by(1)
      end

      it 'return Bad Request if no question params sended' do
        post api_path, params: { access_token: access_token.token }

        expect(response.status).to eq 400
      end

      it 'return Bad Request if bad question params sended' do
        bad_params = { 'bodt': '123123' }
        post api_path, params: { question_id: question.id, answer: bad_params, access_token: access_token.token }

        expect(response.status).to eq 400
      end

      it 'returns public fields' do
        params = { 'body': 'My asnwer' }
        post api_path, params: { question_id: question.id,  answer: params, access_token: access_token.token }

        expect(json['answer']['body']).to eq params[:body]
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:params) { { answer: attributes_for(:answer), access_token: access_token.token } }
      let(:headers) { nil }
    end

    context 'authorized' do
      let(:new_params) { { body: "New Title" } }

      it 'creates new answer' do
        patch api_path, params: { answer: new_params, access_token: access_token.token }
        answer.reload

        expect(answer.body).to eq new_params[:body]
      end

      it 'return Bad Request if no answer params sended' do
        patch api_path, params: { access_token: access_token.token }
        expect(response.status).to eq 400
      end

      it 'return Bad Request if bad answer params sended' do
        bad_params = { 'bodt': '123123' }
        patch api_path, params: { answer: bad_params, access_token: access_token.token }

        expect(question.title).to_not eq bad_params[:titdle]
      end

      it 'returns public fields' do
        patch api_path, params: { answer: new_params, access_token: access_token.token }

        expect(json['answer']['body']).to eq new_params[:body]
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:params) { { access_token: access_token.token } }
      let(:headers) { nil }
    end

    context 'authorized' do
      it 'deletes question' do
        expect { delete api_path, params: { access_token: access_token.token } }.to change(Answer, :count).by(-1)
      end

      it 'return Bad Request if no question found' do
        bad_path = "/api/v1/answers/-1"
        delete bad_path, params: { access_token: access_token.token }

        expect(response.status).to eq 400
      end
    end
  end
end
