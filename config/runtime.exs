import Config

server_expiration = if config_env() == :prod, do: 600, else: 10
  
config(:kobbo, server_expiration: server_expiration)