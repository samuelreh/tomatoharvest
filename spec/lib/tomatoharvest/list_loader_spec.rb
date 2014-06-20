require 'helper'

describe TomatoHarvest::ListLoader do

  describe '.from_file' do

    let(:filename) { TomatoHarvest::ListLoader::FILENAME }

    it 'returns a list' do
      list = described_class.from_file
      expect(list).to be_an_instance_of(TomatoHarvest::List)
    end

    context 'when there is an old list' do

      let(:items) { ['item'] }
      let(:path) { File.join(TomatoHarvest::Config::HOME_DIR, '.toma') }

      before do
        create_yaml_file(path, items)
      end

      it 'moves it to the global location' do
        list = described_class.from_file
        expect(list.count).to eql(1)
      end

      it 'persists the list' do
        described_class.from_file
        list = described_class.from_file
        expect(list.count).to eql(1)
      end

    end

    context 'when there is a global list' do

      let(:items) { ['item'] }

      before do
        path = File.join(TomatoHarvest::Config::GLOBAL_DIR, filename)
        create_yaml_file(path, items)
      end

      it 'returns the global list' do
        list = described_class.from_file
        expect(list.items).to eql(items)
      end

      context 'when there is a local list' do
        let(:local_items) { ['local_item'] }

        before do
          path = File.join(TomatoHarvest::Config::LOCAL_DIR, filename)
          create_yaml_file(path, local_items)
        end

        it 'returns the local list' do
          list = described_class.from_file
          expect(list.items).to eql(local_items)
        end

      end

    end

  end

end
