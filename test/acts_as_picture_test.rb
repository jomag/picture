require "test_helper.rb"

include ActionController::TestProcess

class BasicPicture < ActiveRecord::Base
  set_table_name "pictures"
  acts_as_picture 
  private
  def base_directory
    "/tmp/acts_as_picture_test_basic"
  end
  def base_url
    "/basicurl"
  end
end

class ActsAsPictureTest < Test::Unit::TestCase
  load_schema
  def test_upload
    basic = BasicPicture.new
    basic.file = fixture_file_upload(File.dirname(__FILE__) + '/test.png', 'image/png')
    basic.save!
    assert_equal "/tmp/acts_as_picture_test_basic/test.png", basic.path
  end
end
