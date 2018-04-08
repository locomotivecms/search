describe Locomotive::Search::Backend::Algolia do

  describe '.enabled_for?' do

    let(:site) { build(:site) }

    subject { described_class.enabled_for?(site) }

    it { is_expected.to eq false }

    context 'site with non empty algolia settings' do

      let(:site) { build(:site, :algolia) }
      it { is_expected.to eq true }

    end

  end

  describe '.reset_for?' do

    let(:site) { build(:site) }

    subject { described_class.reset_for?(site) }

    it { is_expected.to eq false }

    context 'site with non empty algolia settings' do

      let(:site) { build(:site, :algolia) }
      it { is_expected.to eq false }

    end

    context 'site with non empty algolia settings + reset set to true' do

      let(:site) { build(:site, metafields: { 'algolia' => { 'application_id' => 42, 'api_key' => 'abcdef', 'reset' => true } }) }
      it { is_expected.to eq true }

    end

  end

  describe '.reset_done!' do

    let(:site) { build(:site, metafields: { 'algolia' => { 'application_id' => 42, 'api_key' => 'abcdef', 'reset' => true } }) }

    subject { described_class.reset_done!(site); site.metafields['algolia']['reset'] }

    it { is_expected.to eq false }

  end

end
