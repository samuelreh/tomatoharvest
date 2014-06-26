# TomatoHarvest
Command line pomodoro timer that logs to Harvest.

[![Code Climate](https://codeclimate.com/github/samuelreh/tomatoharvest.png)](https://codeclimate.com/github/samuelreh/tomatoharvest)

## Usage

    $ toma add "Some Task I Have To Do"
    $ toma list
    $ toma start 1

## Installation

    $ gem install tomatoharvest
    
#### Global Config

Create a file called `~/.toma/config.yaml` with options:
```yaml
  domain: myharvestdomain
  username: username
  password: password
  project: harvest project
  task: harvest task
```

#### Project Config

You can create a config for a specific project as well. Create a file called `path_to_project/.toma/config.yaml` with options:
```yaml
  project: different harvest project
  task: harvest task
```

You can also create a seperate list for a project by creating an empty file at `path_to_project/.toma/list.yaml`

## Contributing

1. Fork it ( https://github.com/samuelreh/tomatoharvest/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits
This application is heavily inspired by https://github.com/visionmedia/pomo.
