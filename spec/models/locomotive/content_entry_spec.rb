describe Locomotive::ContentEntry do

  it 'has a valid content type factory' do
    expect(build(:content_type)).to be_valid
  end

  describe '#content_to_index' do

    let(:content_type) { create(:content_type, :indexed) }
    let(:entry) { content_type.entries.build(attributes_for(:content_entry, :article_attributes, :with_file)) }

    subject { entry.content_to_index }

    it 'stripes HTML tags' do
      is_expected.to eq "Short description here That's good! Click here! 09/26/2015 09/26/2015"
    end

  end

  describe '#data_to_index' do

    let(:content_type)  { create(:content_type, :indexed) }
    let(:entry) { content_type.entries.build(attributes_for(:content_entry, :article_attributes)) }

    subject { entry.data_to_index }

    it 'returns the attributes of the entry' do
      is_expected.to eq(
        '_slug'                   => 'my-first-article',
        '_label'                  => 'My first article',
        '_content_type'           => 'articles',
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
      )
    end

  end

  describe '#index_content' do

    let(:content_type) { create(:content_type, :indexed) }
    let(:entry) { content_type.entries.build(attributes_for(:content_entry, :article_attributes)) }

    it 'performs a job to index the content' do
      expect(Locomotive::SearchIndexContentEntryJob).to receive(:perform_later).with(entry._id.to_s, 'en')
      entry.save
    end

    context 'the search is disabled' do

      before { allow(entry).to receive(:search_enabled?).and_return(false) }

      it "doesn't perform a job to index the content" do
        expect(Locomotive::SearchIndexContentEntryJob).not_to receive(:perform_later)
        entry.save
      end

    end

  end

  describe '#unindex_content' do

    let(:content_type) { create(:content_type, :indexed) }
    let(:entry) { content_type.entries.create(attributes_for(:content_entry, :article_attributes)) }

    it 'performs a job to index the content' do
      expect(Locomotive::SearchDeleteContentEntryIndexJob).to receive(:perform_later).with(entry._id.to_s, 'en')
      entry.destroy
    end

    context 'the search is disabled' do

      before { allow(entry).to receive(:search_enabled?).and_return(false) }

      it "doesn't perform a job to index the content" do
        expect(Locomotive::SearchDeleteContentEntryIndexJob).not_to receive(:perform_later)
        entry.destroy
      end

    end

  end

end
