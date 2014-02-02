require 'bundler/setup'
Bundler.require(:default)
require 'active_record'
require 'minitest/autorun'
require 'mocha/setup'

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

if ENV["VERBOSE"]
  ActiveRecord::Base.logger = Logger.new(STDERR)
else
  Paperclip.options[:log] = false
end

load(File.join(File.dirname(__FILE__), 'schema.rb'))

ActiveRecord::Base.send(:include, Paperclip::Glue)
Paperclip::Meta::Railtie.insert

class Image < ActiveRecord::Base
  has_attached_file :small_image,
    :storage => :filesystem,
    :path => "./spec/tmp/:style/:id.:extension",
    :url => "./spec/tmp/:style/:id.extension"

  has_attached_file :big_image,
    :storage => :filesystem,
    :path => "./spec/tmp/fixtures/tmp/:style/:id.:extension",
    :url => "./spec/tmp/fixtures/tmp/:style/:id.extension",
    :styles => { :thumb => "100x100#" }
end
