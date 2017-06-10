FactoryGirl.define do
  factory :attachment do
    # file "MyString"
    spec_file = "#{Rails.root}/spec/spec_helper.rb"
    file  Rack::Test::UploadedFile.new(File.open(spec_file))
  end
end
