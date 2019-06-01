require 'rails_helper'

RSpec.describe Services::Search do

  describe "#search" do
    let(:params) { { search_type: "", search_string: "" } }
    let(:search) { "some string" }

    context 'search in all records' do
      it 'returns all record if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: nil })
        subject.search(params)
      end

      it 'returns object that contain search string' do
        params[:search_string] = search
        expect(ThinkingSphinx).to receive(:search).with(search, { classes: nil })
        subject.search(params)
      end
    end

    context 'search in questions' do
      before do
        params[:search_type] = 'question'
      end

      it 'returns all questions if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [Question] })
        subject.search(params)
      end

      it 'return specific questions that contains search string' do
        params[:search_string] = search
        expect(ThinkingSphinx).to receive(:search).with(search, { classes: [Question] })
        subject.search(params)
      end
    end

    context 'search in answers' do
      before do
        params[:search_type] = 'answer'
      end

      it 'return all answers if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [Answer] })
        subject.search(params)
      end

      it 'returns object tha contains string' do
        params[:search_string] = search
        expect(ThinkingSphinx).to receive(:search).with(search, { classes: [Answer] })
        subject.search(params)
      end
    end

    context 'search in comments' do
      before do
        params[:search_type] = 'comment'
      end

      it 'return all answers if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [Comment] })
        subject.search(params)
      end

      it 'returns object tha contains string' do
        params[:search_string] = search
        expect(ThinkingSphinx).to receive(:search).with(search, { classes: [Comment] })
        subject.search(params)
      end
    end

    context 'search in users' do
      before do
        params[:search_type] = 'user'
      end

      it 'return all answers if search string empty' do
        expect(ThinkingSphinx).to receive(:search).with("", { classes: [User] })
        subject.search(params)
      end

      it 'returns object tha contains string' do
        params[:search_string] = "someemail@email.com"
        expect(ThinkingSphinx).to receive(:search).with(Riddle::Query.escape("someemail@email.com"), { classes: [User] })
        subject.search(params)
      end
    end
  end
end
