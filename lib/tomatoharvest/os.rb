require 'rbconfig'

module TomatoHarvest
  module OS
    module_function

    def mac?
      (/mac|darwin/ =~ RbConfig::CONFIG['host_os']) != nil
    end

  end
end
