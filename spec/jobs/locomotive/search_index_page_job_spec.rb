describe Locomotive::Search::SearchIndexPageJob do

  let(:job) { described_class.new }

  describe '#perform' do

    let(:backend)   { FooPageBackend.new }
    let(:page)      { create(:page) }
    let(:locale)    { 'en' }

    before { allow(job).to receive(:search_backend).and_return(backend) }

    subject { job.perform(page._id.to_s, locale) }

    it 'calls the Algolia backend' do
      expect(backend).to receive(:save_object).with(
        type:       'page',
        object_id:  page._id.to_s,
        title:      'A simple page',
        content:    'Lorem ipsum - foo - bar Hello world. The search feature is awesome',
        visible:    true,
        data:       { title: 'A simple page', slug: 'simple', fullpath: 'simple' }
      ).and_return(true)
      subject
    end

  end

  class FooPageBackend
    def save_object(type: nil, object_id: nil, title: nil, content: nil, visible: true, data: {})
      true
    end
  end

end
