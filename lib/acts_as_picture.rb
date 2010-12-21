# encoding: utf-8

require 'active_support/core_ext'
require 'RMagick'

require File.join(File.dirname(__FILE__), "acts_as_picture/railtie.rb")

module ActsAsPicture
  autoload :Hook, File.join(File.dirname(__FILE__), "acts_as_picture/hook.rb")
  autoload :InstanceMethods, File.join(File.dirname(__FILE__), "acts_as_picture/instance_methods.rb")
end

