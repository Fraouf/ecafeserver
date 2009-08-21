# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ecafeserver_session',
  :secret      => 'ccb254ef48dd47dbcd3087c40f3b4d7e0b704d37ee9f125ca2f8dfcb93c3af5691322018651e75e728b1491778239d3da67aa1d0357a8d4d85d9dd36eef81404'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
