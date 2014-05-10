# TomatoHarvest
Command line pomodoro timer that logs to Harvest.

[![Code Climate](https://codeclimate.com/github/samuelreh/tomatoharvest.png)](https://codeclimate.com/github/samuelreh/tomatoharvest)

## Installation

    $ gem install tomatoharvest
    
Create a file called ~/.tomaconfig with options:
```yaml
  domain: myharvestdomain
  username: username
  password: password
  project: harvest project
  task: harvest task
```

## Usage

    $ toma add "Some Task I Have To Do"
    $ toma list
    $ toma start 1

## Contributing

1. Fork it ( https://github.com/samuelreh/tomatoharvest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits
This application is heavily inspired by https://github.com/visionmedia/pomo.
