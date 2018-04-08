describe Locomotive::Site do

  it 'has a valid factory' do
    expect(build(:site)).to be_valid
  end

  describe 'enable search for an existing site' do

    let!(:site) { create(:site) }

    before { site.metafields = { 'algolia' => { 'application_id' => '42', 'api_key' => 'abcdefgh', 'reset' => true } } }

    it 'create the indices and index the content' do
      expect(Locomotive::SearchIndexSiteJob).to receive(:perform_later).with(site._id.to_s)
      site.save
      expect(site.metafields['algolia']['reset']).to eq false
    end

  end

end
