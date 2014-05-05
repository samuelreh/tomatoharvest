require 'rbconfig'

module Pom
  module OS
    module_function

    def mac?
      (/mac|darwin/ =~ RbConfig::CONFIG['host_os']) != nil
    end

  end
end
