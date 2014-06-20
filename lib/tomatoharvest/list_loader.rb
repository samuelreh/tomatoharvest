module TomatoHarvest

  class ListLoader

    FILENAME = 'list.yaml'

    class << self

      def from_file
        local_path  = list_path(TomatoHarvest::Config::LOCAL_DIR)

        if File.exists? local_path
          List.init_and_load(local_path)
        else
          load_old_list || List.init_and_load(global_path)
        end
      end

      def load_old_list
        old_path = File.join(TomatoHarvest::Config::HOME_DIR, '.toma')

        if exists_as_file(old_path)
          old_list = List.init_and_load(old_path)
          File.delete old_path
          List.new(global_path, old_list.items).save!
        end
      end

      def exists_as_file(path)
        File.exists?(path) && !File.directory?(path)
      end

      def global_path
        list_path(TomatoHarvest::Config::GLOBAL_DIR)
      end

      def list_path(dir)
        File.join(dir, FILENAME)
      end

    end

  end

end
