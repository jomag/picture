# encoding: utf-8

module ActsAsPicture::Hook
  def acts_as_picture(*args) 
    options = args.extract_options!

    cattr_accessor :picture_sizes
    cattr_accessor :enable_picture_debug

    include ActsAsPicture::InstanceMethods

    after_create :move_uploaded_file

    if options[:debug]
      puts "Fjomp::ActsAsPicture: Debug enabled!"
      self.enable_picture_debug = true
    else
      self.enable_picture_debug = false
    end

    # Create methods "name_path" and "name_url" for each named picture
    # size in the "sizes" hash.
    if options.include? :sizes
      self.picture_sizes = options[:sizes]

      self.picture_sizes.each do |name,sz|
        define_method "#{name}_path" do
          path(name)
        end

        define_method "#{name}_url" do
          url(name)
        end
      end
    else
      self.picture_sizes = Hash.new
    end
  end
end

