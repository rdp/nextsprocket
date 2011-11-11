db_config = YAML::load(File.read(File.join(Rails.root, "/config/mongo_db.yml")))

if db_config[Rails.env]
  mongo = db_config[Rails.env]
  MongoMapper.connection = Mongo::Connection.new(mongo['host'] || 'localhost',
                                                 mongo['port'] || 27017,
                                                :logger => Rails.logger)
  MongoMapper.database = mongo['database']
  
  if mongo['username'] && mongo['password']
    MongoMapper.database.authenticate(mongo['username'], mongo['password'])
  end
end

