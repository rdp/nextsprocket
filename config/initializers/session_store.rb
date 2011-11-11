# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gll-web_session',
  :secret      => '8dd71d132fceb99ca73eb74197abc3fd1d5502801934563e8cadcc7fd11cf2b1a8370b2c0418c7acdc934570a316a383374d58eff9f305470fb756795d4d03c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
