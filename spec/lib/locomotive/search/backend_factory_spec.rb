describe Locomotive::Search::BackendFactory do

  let(:name)      { 'foo' }
  let(:instance)  { described_class.new(name) }

  describe 'unknown backend' do

    let(:name) { 'foobar' }

    subject { instance }

    it 'raises an exception' do
      expect { subject }.to raise_error("'foobar' is not a valid backend")
    end

  end

  describe 'create an instance of a backend' do

    let(:name)    { SimpleBackend }
    let(:site)    { build(:site) }
    let(:locale)  { :en }

    subject { instance.create(site, locale) }

    it { is_expected.not_to eq nil }

    context 'the backend is disabled' do

      let(:name) { DisabledBackend }
      it { is_expected.to eq nil }

    end

  end

  class SimpleBackend
    def initialize(site, locale); true; end
    def valid?; true; end
  end

  class DisabledBackend
    def initialize(site, locale); true; end
    def valid?; false; end
  end

end
