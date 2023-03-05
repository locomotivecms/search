describe 'Search with Algolia' do

  context 'content added to a site created with Algolia enabled' do

    let(:site) { create(:site, :algolia, handle: 'aic') }
    let(:content_type) { create(:content_type, site: site) }

    it 'indexes content of a site and search for it' do
      perform_enqueued_jobs do
        # first index a new page
        page = create(:page, site: site)

        # then index a couple of content entries
        content_type.entries.create(attributes_for(:content_entry, :article_attributes))
        content_type.entries.create(title: 'Hello world', short_description: 'Hard to find', description: 'Lorem ipsum...', visible: true)
        content_type.entries.create(title: 'Another world', short_description: 'Something in the way', description: 'No one knows', visible: true)
      end

      response = ask_algolia('aic', 'knows')

      expect(response[:nbHits]).to eq 1
      expect(response[:hits][0][:title]).to eq 'Another world'

      expect { site.destroy }.not_to raise_exception
    end

  end

  context 'index a site with non indexed content' do

    let(:site) { create(:site, handle: 'aic-two') }
    let(:content_type) { create(:content_type, site: site) }

    it 'indexes content of a site and search for it' do
      perform_enqueued_jobs do
        # first index a new page
        page = create(:page, site: site)

        # then index a couple of content entries
        content_type.entries.create(attributes_for(:content_entry, :article_attributes))
        content_type.entries.create(title: 'Hello world', short_description: 'Hard to find', description: 'Lorem ipsum...', visible: true)
        content_type.entries.create(title: 'Another world', short_description: 'Something in the way', description: 'No one knows', visible: true)

        # at this point, Algolia was not involved
        site.metafields = { 'algolia' => { 'application_id' => ENV['ALGOLIA_APPLICATION_ID'], 'api_key' => ENV['ALGOLIA_API_KEY'], 'reset' => true } }
        site.save
      end

      response = ask_algolia('aic-two', 'knows')

      expect(response[:nbHits]).to eq 1
      expect(response[:hits][0][:title]).to eq 'Another world'
    end

  end

  def ask_algolia(site_handle, query)
    client = Algolia::Search::Client.create(ENV['ALGOLIA_APPLICATION_ID'], ENV['ALGOLIA_API_KEY'])
    index     = client.init_index("locomotive-test-#{site_handle}-en")
    response  = nil
    retries   = 0

    # Wait for Algolia to create indices and index content
    while response.nil? && retries < 5 do
      begin
        response = index.search('knows')
        raise 'no results' if response['nbHits'] == 0
      rescue Exception => e
        response = nil
        retries += 1
        sleep(1) # next try in one second
      end
    end

    raise "Unable to query Algolia, message: #{e.message}" if retries >= 5 && response.nil?

    response
  end

end
