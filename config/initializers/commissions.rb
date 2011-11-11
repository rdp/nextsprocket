config = YAML.load_file(File.join(Rails.root, "config/next_sprocket.yml"))[Rails.env]

COMMISSION_PERCENTAGE = config['commission_percentage']
READ_COMMISSION_PERCENTAGE = "#{COMMISSION_PERCENTAGE*100}%"
COMMISSION_EMAIL = config['commission_email']
