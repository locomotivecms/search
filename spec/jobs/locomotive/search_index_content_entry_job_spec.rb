describe Locomotive::Search::SearchIndexContentEntryJob do

  let(:job) { described_class.new }

  describe '#perform' do

    let(:backend)       { FooEntryBackend.new }
    let(:content_type)  { create(:content_type, :indexed) }
    let(:entry)         { content_type.entries.create(attributes_for(:content_entry, :article_attributes)) }
    let(:locale)        { 'en' }

    before { allow(job).to receive(:search_backend).and_return(backend) }

    subject { job.perform(entry._id.to_s, locale) }

    it 'calls the Algolia backend' do
      expect(backend).to receive(:save_object).with(
        type:       'articles',
        object_id:  entry._id.to_s,
        title:      'My first article',
        content:    "Short description here That's good! Click here! 09/26/2015 09/26/2015",
        visible:    true,
        data:       {
          '_slug'                   => 'my-first-article',
          '_content_type'           => 'articles',
          '_label'                  => 'My first article',
          'title'                   => 'My first article',
          'short_description'       => '<span>Short description here</span>',
          'description'             => "<p>That's <strong>good!</strong> <a href='#'>Click here!</a></p>",
          'visible'                 => true,
          'published_at'            => '09/26/2015',
          'formatted_published_at'  => '09/26/2015',
          'author'                  => {
            '_content_type' => 'authors',
            '_slug'         => 'john',
            '_label'        => 'John Doe'
          }
        }
      ).and_return(true)
      subject
    end

  end

  class FooEntryBackend
    def save_object(type: nil, object_id: nil, title: nil, content: nil, visible: true, data: {})
      true
    end
  end

end
