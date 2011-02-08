# encoding: utf-8

module ActsAsPicture::InstanceMethods
  # After a picture has been uploaded, call this method on a new Picture-instance
  # with the file field data as parameter. The "after_save" method will care
  # for copying the file from its temporary location.
  def file=(file_data)
    puts "DEBUG: Original file: #{file_data.original_filename} (#{file_data.size} bytes)" if self.enable_picture_debug

    @temporary_file = file_data
    self.filename = ActsAsPicture.sanitize_filename(base_part_of(file_data.original_filename))
    self.content_type = file_data.content_type.strip
  end

  def set_file_data(original_filename, content_type)
    @temporary_file = File.open original_filename
    self.filename = ActsAsPicture.sanitize_filename(base_part_of(original_filename))
    self.content_type = content_type
  end

  def ActsAsPicture.sanitize_filename(fn)
    fn = fn.gsub('å', 'aa').gsub('Å', 'Aa')
    fn = fn.gsub('ä', 'ae').gsub('Ä', 'AE')
    fn = fn.gsub('æ', 'ae').gsub('Æ', 'AE')
    fn = fn.gsub('ö', 'oe').gsub('Ö', 'OE')
    fn = fn.gsub('ø', 'oe').gsub('Ø', 'OE')
    fn = fn.gsub /[^\w\.\-]/, '-'
    fn
  end

  # After picture model has been stored in the database, copy the
  # file from the temporary upload directory to its final directory.
  def move_uploaded_file
    puts "DEBUG: Moving uploaded file from #{@temporary_file.original_filename} to #{base_directory}" if self.enable_picture_debug

    FileUtils.mkpath(base_directory)

    File.open(path, "wb") do |f|
      @temporary_file.rewind
      f.write(@temporary_file.read)
    end
  end

  def url(sz = false)
    if sz
      p = File.join(base_directory, sz.to_s, filename)

      unless File.exist?(p)
        FileUtils.mkpath(File.dirname(p))
        scale_picture(p, picture_sizes[sz][:width], picture_sizes[sz][:height])

        puts "DEBUG: Scaling failed! No scaled picture found." unless File.exist?(p)
      end

      u = "#{base_url}/#{sz.to_s}/#{filename}"
    else
      u = "#{base_url}/#{filename}"
    end

    puts "DEBUG: Picture URL = #{u}" if self.enable_picture_debug
    u
  end

  def path(sz = false)
    if sz
      File.join(base_directory, sz.to_s, filename)
    else
      File.join(base_directory, filename)
    end
  end

  # Return the original size of the image
  def width
    # FIXME: save this and height in db instead
    im = Magick::Image.read path
    return im[0].columns
  end

  # Return the original height of the image
  def height
    im = Magick::Image.read path
    return im[0].rows
  end

  def scale_picture(trg_path, width, height)
    begin
      im_o = Magick::Image.read path
    rescue
      # raise "Failed to open source image or empty file"
      puts "DEBUG: Failed to open source image or empty file"
      return 
    end

    width = 0 if width.nil?
    height = 0 if height.nil?

    # No size specified. Make a copy.
    if width == 0 and height == 0 then
      im_o[0].write trg_path
      return
    end

    # Only width specified. Make a copy with less or equal width.
    if height == 0 then
      if im_o[0].columns <= width then
        im_o[0].write trg_path
      else
        w = width
        h = ((width+0.0) / (im_o[0].columns+0.0)) * (im_o[0].rows+0.0)
        im_o[0].scale(w, h).write trg_path
      end
      return
    end

    # Only height specified. Make a copy with less or equal height.
    if width == 0 then
      if im_o[0].rows <= height then
        im_o[0].write trg_path
      else
        w = ((height+0.0) / (im_o[0].rows+0.0)) * (im_o[0].columns+0.0)
        h = height
        im_o[0].scale(w, h).write trg_path
      end
      return
    end

    # Width and height specified. Make a copy that fits in both directions.
    if im_o[0].columns > im_o[0].rows then
      w = width
      h = ((width+0.0) / (im_o[0].columns+0.0)) * (im_o[0].rows+0.0)
    else
      w = ((height+0.0) / (im_o[0].rows+0.0)) * (im_o[0].columns+0.0)
      h = height
    end

    im_o[0].scale(w, h).write trg_path
  end

  # FIXME: this method is available in Attachment as well. Could we define it globally somewhere?
  def base_part_of(filename)
    b = File.basename(filename.strip)
    # replace leading period, whitespace and \ / : * ? " ' < > |
    b.gsub(%r{^\.|[\s/\\\*\:\?'"<>\|]}, '_')
  end
end

