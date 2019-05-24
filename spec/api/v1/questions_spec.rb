require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'reuturns 200 status' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end
    end
  end

  #включает в себя список комментариев, список прикрепленных файлов в виде url и список прикрепленных ссылок
  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question_with_all_appends) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      it 'returns nil if question does not exists' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response['body']).to be_nil
      end

      context 'question exists' do
        before { get api_path, params: { id: question.id, access_token: access_token.token }, headers: headers }

        it 'reuturns 200 status' do
          expect(response).to be_successful
        end

        it 'returns public fields' do
          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq question.send(attr).as_json
          end
        end

        it 'contains user object' do
          expect(question_response['user']['id']).to eq question.user.id
        end

        context 'links' do
          let(:link_response) { question_response['links'].first }
          let(:link) { question.links.first }

          it 'returns list of links' do
            expect(question_response['links'].size).to eq 2
          end

          it 'returns all public fields' do
            %w[id name url].each do |attr|
              expect(link_response[attr]).to eq link.send(attr).as_json
            end
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

          it 'returns list of comments' do
            expect(question_response['comments'].size).to eq 2
          end

          it 'returns all public fields' do
            %w[id body user_id].each do |attr|
              expect(comment_response[attr]).to eq comment.send(attr).as_json
            end
          end
        end
      end
    end
  end

  # Создания, редактирования и удаления вопроса (без возможности прикреплять файлы)
  describe 'POST /api/v1/questions' do
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:headers) { nil }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'reuturns 200 status' do
        post api_path, params: { question: attributes_for(:question), access_token: access_token.token }
        expect(response).to be_successful
      end

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

  describe 'POST /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:headers) { nil }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'reuturns 200 status' do
        patch api_path, params: { question: attributes_for(:question), access_token: access_token.token }
        expect(response).to be_successful
      end

      it 'creates new question' do
        expect { post api_path, params: { question: attributes_for(:question), access_token: access_token.token }}.to change(Question, :count).by(1)
      end

      it 'return Bad Request if no question params sended' do
        patch api_path, params: { access_token: access_token.token }
        expect(response.status).to eq 400
      end

      it 'return Bad Request if bad question params sended' do
        bad_params = { 'titdle': '12312', 'bodt': '123123' }

        patch api_path, params: { question: bad_params, access_token: access_token.token }
        expect(response.status).to eq 400
      end
    end
  end
end
