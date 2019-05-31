require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "POST #search" do
    let(:users) { create_list(:user, 2) }
    let(:questions) { create_list(:question, 3, user: users.first) }
    let(:answers) { create_list(:answer, 2, question: questions.first) }
    let(:comments) { create_list(:comment, 3, commentable: answers.last) }
    let(:params) { { search_type: "", search: "" } }

    context 'search in all records' do
      it 'returns all record if search string empty' do
        objects = users + questions + answers + comments
        expect(ThinkingSphinx).to receive(:search).with("", { classes: nil }).and_return(objects)
        post :search, params: params
        expect(objects.count).to eq 10
      end

      it 'returns object that contain search string' do
        objects = [users.first] + questions
        params[:search] = "#{users.first.email}"
        expect(ThinkingSphinx).to receive(:search).with(users.first.email, { classes: nil }).and_return(objects)
        post :search, params: params
        expect(objects.count).to eq 4
      end
    end

    context 'search in questions' do
      before do
        params[:search_type] = 'question'
      end

      it 'returns all questions if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [Question] }).and_return(questions)
        post :search, params: params
        expect(questions.count).to eq 3
      end

      it 'return specific questions that contains search string' do
        params[:search] = "#{questions.first.body}"
        objects = [questions.first]
        expect(ThinkingSphinx).to receive(:search).with(questions.first.body, { classes: [Question] }).and_return(objects)
        post :search, params: params
        expect(objects.count).to eq 1
      end
    end

    context 'search in answers' do
      before do
        params[:search_type] = 'answer'
      end

      it 'return all answers if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [Answer] }).and_return(answers)
        post :search, params: params
        expect(answers.count).to eq 2
      end

      it 'returns object tha contains string' do
        objects = [answers.first, create(:answer, body: answers.first.body)]
        params[:search] = "#{answers.first.body}"
        expect(ThinkingSphinx).to receive(:search).with(answers.first.body, { classes: [Answer] }).and_return(objects)
        post :search, params: params
        expect(objects.count).to eq 2
      end
    end

    context 'search in comments' do
      before do
        params[:search_type] = 'comment'
      end

      it 'return all answers if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [Comment] }).and_return(comments)
        post :search, params: params
        expect(comments.count).to eq 3
      end

      it 'returns object tha contains string' do
        objects = [comments.first]
        params[:search] = "#{comments.first.body}"
        expect(ThinkingSphinx).to receive(:search).with(comments.first.body, { classes: [Comment] }).and_return(objects)
        post :search, params: params
        expect(objects.count).to eq 1
      end
    end

    context 'search in users' do
      before do
        params[:search_type] = 'user'
      end

      it 'return all answers if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [User] }).and_return(users)
        post :search, params: params
        expect(users.count).to eq 2
      end

      it 'returns object tha contains string' do
        objects = [users.first]
        params[:search] = "#{users.first.email}"
        expect(ThinkingSphinx).to receive(:search).with(users.first.email, { classes: [User] }).and_return(objects)
        post :search, params: params
        expect(objects.count).to eq 1
      end
    end
  end
end
