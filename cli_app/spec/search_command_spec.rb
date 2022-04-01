require './lib/search_command'

RSpec.describe SearchCommand do

  describe '.to_s_query' do
    let(:query) {['rails', 'on']}
    subject(:command) { SearchCommand.to_s_query(query) }

    it{ is_expected.to eq 'rails+on' }
    
  end

  describe '#result' do
    let(:query) {'rails'}
    subject(:search) {SearchCommand.new(query).result}

    it { is_expected.to be_a SearchCommand::SearchResult}
  end

  describe '.removeOptions' do
    let(:args) {['rails', 'on', '--most-downloads-first']}
    subject(:search) {SearchCommand.removeOptions(args)}

    it { is_expected.to eq ['rails', 'on']}
  end

end