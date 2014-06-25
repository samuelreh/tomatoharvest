require 'helper'

describe TomatoHarvest::List do

  let(:path) { TomatoHarvest::ListLoader.global_path }
  let(:list) { TomatoHarvest::List.new(path) }

  def add_task(name)
    task = TomatoHarvest::Task.new(name)
    list.add(task)
  end

  describe 'load!' do

    it 'doesnt load if file is empty' do
      create_file(path, "")
      list.load!
      expect(list.items).to eql([])
    end

  end

  describe '.add' do

    it 'adds to the list' do
      add_task('foo')
      expect(list.items.first).to be_an_instance_of(TomatoHarvest::Task)
    end

    it 'should have two items' do
      add_task('foo')
      add_task('bar')
      expect(list.count).to eql(2)
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
      expect(list.count).to eql(0)
    end

  end

end
