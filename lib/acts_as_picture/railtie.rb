# encoding: utf-8

require 'rails'
require 'acts_as_picture'

module Fjomp
  module ActsAsPicture
    class Railtie < Rails::Railtie
      config.to_prepare do
        ApplicationController.send(:extend, ActsAsPicture::Hook)
      end
    end
  end
end

