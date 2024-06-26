defmodule Kobbo.System do
  def start_link do
    children = [
      Kobbo.ProcessRegistry,
      Kobbo.Database,
      Kobbo.Cache]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end