defmodule Kobbo.Application do
  use Application
  
  def start(_start_type, _start_args) do
    Kobbo.System.start_link()
  end
  
end