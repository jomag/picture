# encoding: utf-8
require 'rails'
require 'acts_as_picture'

module ActsAsPicture
  class Railtie < Rails::Railtie
    config.to_prepare do
      ActiveRecord::Base.send(:extend, ActsAsPicture::Hook)
    end
  end
end

