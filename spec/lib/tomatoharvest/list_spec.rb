require 'helper'

describe TomatoHarvest::List do

  let(:list) { TomatoHarvest::List.local_or_global }

  def add_task(name)
    task = TomatoHarvest::Task.new(name)
    list.add(task)
  end

  describe '.local_or_global' do

    let(:filename) { TomatoHarvest::List::FILENAME }

    it 'returns a list' do
      list = described_class.local_or_global
      expect(list).to be_an_instance_of(described_class)
    end

    context 'when there is a global list' do

      let(:items) { ['item'] }

      before do
        path = File.join(TomatoHarvest::Config::GLOBAL_DIR, filename)
        create_yaml_file(path, items)
      end

      it 'returns the global list' do
        list = described_class.local_or_global
        expect(list.items).to eql(items)
      end

      context 'when there is a local list' do
        let(:local_items) { ['local_item'] }

        before do
          path = File.join(TomatoHarvest::Config::LOCAL_DIR, filename)
          create_yaml_file(path, local_items)
        end

        it 'returns the local list' do
          list = described_class.local_or_global
          expect(list.items).to eql(local_items)
        end

      end

    end

  end

  describe '.add' do

    it 'adds to the list' do
      add_task('foo')
      expect(list.all.first).to be_an_instance_of(TomatoHarvest::Task)
    end

  end

  describe '.list' do

    it 'should have two items' do
      add_task('foo')
      add_task('bar')
      expect(list.all.count).to eql(2)
    end

  end

  describe '.find' do

    it 'returns the task with the corresponding id' do
      add_task('foo')
      add_task('bar')
      expect(list.find(1).name).to eql('foo')
      expect(list.find(2).name).to eql('bar')
    end

  end

  describe '#add' do

    it 'adds the task to the items array' do
      task = TomatoHarvest::Task.new('foo')
      list.add(task)
      expect(list.items.first.id).to eql(1)
    end

  end

  describe '.remove' do

    it 'removes the task from the item array' do
      add_task('foo')
      list.remove(1)
      expect(list.all.count).to eql(0)
    end

  end

end
