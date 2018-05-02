describe Locomotive::SearchDeleteSiteIndicesJob do

  let(:job) { described_class.new }

  describe '#perform' do

    let(:backend)   { FooSiteBackend.new }
    let(:site)      { create(:site, :algolia) }

    before { allow(job).to receive(:search_backend).and_return(backend) }

    subject { job.perform('acme', %({ "algolia": { "api_key": "42", "app_id": "42" } })) }

    it 'calls the Algolia backend' do
      expect(backend).to receive(:clear_all_indices).and_return(true)
      subject
    end

  end

  class FooSiteBackend
    def clear_all_indices
      true
    end
  end

end
