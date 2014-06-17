module HarvestHelpers
  def stub_harvest
    body = {
      projects: [ {
        name: 'Pomdoro',
        id: 1,
        tasks: [
          {
            name: 'Ruby Development',
            id: 1
          }
        ]
      } ],
      day_entries: []
    }

    stub_request(:get, /https:\/\/user:password@domain.harvestapp.com\/daily\/.*/).
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json; charset=utf-8', 'User-Agent'=>'Harvestable/2.0.0'}).
      to_return(:status => 200, :body => body.to_json, :headers => {})

    stub_request(:post, "https://user:password@domain.harvestapp.com/daily/add").
      with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json; charset=utf-8', 'User-Agent'=>'Harvestable/2.0.0'}).
      to_return(:status => 200, :body => "", :headers => {})
  end
end
