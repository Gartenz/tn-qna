require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }

  describe 'GET /api/v1/questions/:queston_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { question_id: question.id, access_token: access_token.token }, headers: headers }

      it 'reuturns 200 status' do
        expect(response).to be_successful
      end

      it 'contains list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'contains all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  #включает в себя список комментариев, список прикрепленных файлов в виде url и список прикрепленных ссылок
  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer_with_all_appends) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      it 'returns nil if answer does not exists' do
        get api_path, params: { access_token: access_token.token }, headers: headers
        expect(response['body']).to be_nil
      end

      context 'question exists' do
        before { get api_path, params: { id: answer.id, access_token: access_token.token }, headers: headers }

        it 'reuturns 200 status' do
          expect(response).to be_successful
        end

        it 'returns public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'contains user object' do
          expect(answer_response['user']['id']).to eq answer.user.id
        end

        context 'links' do
          let(:link_response) { answer_response['links'].first }
          let(:link) { answer.links.first }

          it 'returns list of links' do
            expect(answer_response['links'].size).to eq 2
          end

          it 'returns all public fields' do
            %w[id name url].each do |attr|
              expect(link_response[attr]).to eq link.send(attr).as_json
            end
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

          it 'returns list of comments' do
            expect(answer_response['comments'].size).to eq 2
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
end
