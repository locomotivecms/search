describe Locomotive::Page do

  it 'has a valid factory' do
    expect(build(:page)).to be_valid
  end

  describe '#content_to_index' do

    let(:page) { build(:page, :indexed) }

    subject { page.content_to_index }

    it 'stripes HTML tags and removes URLS' do
      is_expected.to eq 'Lorem ipsum - foo - bar Hello world. The search feature is awesome'
    end

  end

  describe '#index_content' do

    let(:page) { build(:page, :indexed) }

    it 'performs a job to index the content' do
      expect(Locomotive::SearchIndexPageJob).to receive(:perform_later).with(page._id.to_s, 'en')
      page.save
    end

    context 'the search is disabled' do

      before { allow(page).to receive(:search_enabled?).and_return(false) }

      it "doesn't perform a job to index the content" do
        expect(Locomotive::SearchIndexPageJob).not_to receive(:perform_later)
        page.save
      end

    end

    context 'saving the 404 error page' do

      let(:page) { build(:page, :page_not_found) }

      it "doesn't perform a job to index the content" do
        expect(Locomotive::SearchIndexPageJob).not_to receive(:perform_later)
        page.save
      end

    end

  end

  describe '#unindex_content' do

    let!(:page) { create(:page, :indexed) }

    it 'performs a job to index the content' do
      expect(Locomotive::SearchDeletePageIndexJob).to receive(:perform_later).with(page._id.to_s, 'en')
      page.destroy
    end

    context 'the search is disabled' do

      before { allow(page).to receive(:search_enabled?).and_return(false) }

      it "doesn't perform a job to index the content" do
        expect(Locomotive::SearchDeletePageIndexJob).not_to receive(:perform_later)
        page.destroy
      end

    end

    context 'saving the 404 error page' do

      let(:page) { build(:page, :page_not_found) }

      it "doesn't perform a job to index the content" do
        expect(Locomotive::SearchDeletePageIndexJob).not_to receive(:perform_later)
        page.destroy
      end

    end

  end

end
