require 'helper'

describe Pom::TimeEntry do

  describe '#test' do

    let(:entry) do
      described_class.new.tap do |entry|
        entry.stub(project: double, task: double)
      end
    end

    it "raises an error if project can't be found" do
      entry.stub(project: nil)
      expect{ entry.test }.to raise_error("Couldn't find project")
    end

    it "raises an error if task can't be found" do
      entry.stub(task: nil)
      expect{ entry.test }.to raise_error("Couldn't find task type")
    end

  end

  describe '#log' do

    context 'task is already logged today' do
      let(:options) do
        {
          'domain' => 'domain',
          'username' => 'user',
          'password' => 'password',
          'project' => 'Pomodoro',
          'type' => 'Ruby Development',
          'name' => 'Template Refactoring'
        }
      end

      before do
        body = {
          projects: [ {
            name: 'Pomodoro',
            id: 1,
            tasks: [
              {
                name: 'Ruby Development',
                id: 1
              }
            ]
          } ],

          day_entries: [ {
            notes: 'Template Refactoring',
            project_id: 1,
            task_id: 1,
            hours: 1
          } ]
        }

        stub_request(:get, /https:\/\/user:password@domain.harvestapp.com\/daily\/.*/).
          to_return(:status => 200, :body => body.to_json, :headers => {})
      end

      it 'updates exisiting entry' do
        update_url = "https://user:password@domain.harvestapp.com/daily/update/"
        body = {
          notes: "Template Refactoring",
          project_id: 1,
          task_id: 1,
          hours: 1.5,
          spent_at: Date.today.strftime("%Y-%m-%d")
        }
        stub = stub_request(:put, update_url).with(:body => body.to_json)

        entry = Pom::TimeEntry.new(options)
        entry.log(60 * 30)

        stub.should have_been_requested
      end

    end

  end

  describe '#notes' do

    it 'concats name and description' do
      entry = described_class.new('name' => "Name")
      expect(entry.notes).to eql("Name")
    end

  end

  describe '#hours' do

    it 'converts minutes to hours' do
      expect(described_class.new.seconds_to_hours(60 * 60)).to be(1.00)
    end

    it 'round to hundreths' do
      expect(described_class.new.seconds_to_hours(61 * 60)).to be(1.02)
    end

  end

end
