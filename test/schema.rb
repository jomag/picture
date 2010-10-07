ActiveRecord::Schema.define(:version => 0) do
  create_table :pictures, :force => true do |t|
    t.string :filename, :null => false
    t.string :content_type, :null => false
  end
end
