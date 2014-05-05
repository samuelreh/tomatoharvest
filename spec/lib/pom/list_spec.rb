require 'helper'

describe Pom::List do

  def add_task(name)
    task = Pom::Task.new(name)
    Pom::List.add(task)
  end

  describe '.add' do

    it 'adds to the list' do
      add_task('foo')
      expect(described_class.all.first).to be_an_instance_of(Pom::Task)
    end

  end

  describe '.list' do

    it 'should have two items' do
      add_task('foo')
      add_task('bar')
      expect(described_class.all.count).to eql(2)
    end

  end

  describe '.find' do

    it 'returns the task with the corresponding id' do
      add_task('foo')
      add_task('bar')
      expect(described_class.find(1).name).to eql('foo')
      expect(described_class.find(2).name).to eql('bar')
    end

  end

  describe '#add' do

    it 'adds the task to the items array' do
      task = Pom::Task.new('foo')
      list = described_class.new
      list.add(task)
      expect(list.items.first.id).to eql(1)
    end

  end

end