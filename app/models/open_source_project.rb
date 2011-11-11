class OpenSourceProject
  include MongoMapper::Document
  include SimplesIdeias::Acts::Permalink

  has_permalink :name, :unique => true, :to_param => :permalink

  key :name, String, :required => true, :unique => true
  key :permalink, String
  key :description, String
  key :homepage_url, String
  key :download_url, String
  key :bugtracker_url, String
  key :user_count, Integer
  key :language, String
  key :licenses, Array


end