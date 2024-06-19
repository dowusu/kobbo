defmodule Kobbo.Cache do
  use DynamicSupervisor
  
  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, nil,name: __MODULE__)
  end
  
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
  
  defp start_child(todo_name) do
    case DynamicSupervisor.start_child(__MODULE__, {
      Kobbo.Server, todo_name
    }) do
     {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
  
  def server_process(todo_name) do
    start_child(todo_name)
  end
end