module TomatoHarvest
  class Tmux

    def update(time)
      write_tmux_time time
      refresh_tmux_status_bar
    end

    private

    def tmux_time(time)
      mm, ss = time.divmod(60)
      ss = ss.to_s.rjust(2, "0")
      "#[default]#[fg=green]#{mm}:#{ss}#[default]"
    end

    def write_tmux_time(time)
      path = File.join(TomatoHarvest::Config::GLOBAL_DIR, 'tmux')
      File.open(path, 'w') do |file|
        file.write tmux_time(time)
      end
    end

    def refresh_tmux_status_bar
      pid = Process.fork do
        exec "tmux refresh-client -S -t $(tmux list-clients -F '\#{client_tty}')"
      end
      Process.detach(pid)
    end

  end
end
