shared_examples_for "API Listable" do
  context 'expect to return' do
    it 'list of items' do
      expect(list_response.size).to eq list.count
    end

    it 'all public fields' do
      fields.each do |attr|
        expect(list_response.first[attr]).to eq list.first.send(attr).as_json
      end
    end
  end
end
