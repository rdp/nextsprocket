namespace :ohloh_api do
  desc "Import MongoDB"
  task(:import_mongodb => :environment) do
    OhlohParser.import_ohloh_dir('/tmp/ohloh_files')
  end
end
