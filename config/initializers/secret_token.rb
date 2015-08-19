# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
PPCBoard20::Application.config.secret_token = 'c765eaed1cdd79c64a69c97cb3a0b9539396e5bb0d6c5cc3640e27cc77f1f188d1d98197c1408a7b6b6cece805e7d11cf564487d04c6d42448c0dda9b6ab8983'
PPCBoard20::Application.config.secret_key_base = ENV['RAILS_SECRET_KEY'] || '9a1cee0d939f832a61a41cd460a18246d9d953e122691f39ffb5d418aa7ebab6b50572c39c96b6392d69b4e3eb4bc74b62f95e56f95e7cd349a5800488a37faa'
