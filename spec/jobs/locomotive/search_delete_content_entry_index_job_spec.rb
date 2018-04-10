describe Locomotive::SearchDeleteContentEntryIndexJob do

  let(:job) { described_class.new }

  describe '#perform' do

    let(:backend)       { FooEntryBackend.new }
    let(:content_type)  { create(:content_type, :indexed) }
    let(:entry)         { content_type.entries.create(attributes_for(:content_entry, :article_attributes)) }
    let(:locale)        { 'en' }

    before { allow(job).to receive(:search_backend).and_return(backend) }

    subject { job.perform(entry._id.to_s, locale) }

    it 'calls the Algolia backend' do
      expect(backend).to receive(:delete_object).with('articles', entry._id).and_return(true)
      subject
    end

  end

  class FooEntryBackend
    def delete_object(type, entry_id)
      true
    end
  end

end
