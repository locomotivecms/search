describe Locomotive::SearchDeletePageIndexJob do

  let(:job) { described_class.new }

  describe '#perform' do

    let(:backend)   { FooPageBackend.new }
    let(:page)      { create(:page) }
    let(:locale)    { 'en' }

    before { allow(job).to receive(:search_backend).and_return(backend) }

    subject { job.perform(page._id.to_s, locale) }

    it 'calls the Algolia backend' do
      expect(backend).to receive(:delete_object).with('page', page._id).and_return(true)
      subject
    end

  end

  class FooPageBackend
    def delete_object(type, page_id)
      true
    end
  end

end
