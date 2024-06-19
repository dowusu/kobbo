defmodule Kobbo.Server do
  use GenServer
  alias Kobbo.List
  def start_link(todo_name) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(todo_name))
  end
  
  defp via_tuple(name) do
    Kobbo.ProcessRegistry.via_tuple({__MODULE__, name})
  end
  
  def add_entry(server, entry) do
    GenServer.call(server, {:add_entry,entry})
  end
  
  def entries(server, date) do
    GenServer.call(server, {:entries, date})
  end
  
  def init(_) do
    {:ok, List.new()}
  end
  
  def handle_call({:add_entry, entry}, _from, list) do
    {:reply, :ok, List.add_entry(list, entry)}
  end
  
  def handle_call({:entries, date}, _from, list) do
    {:reply, List.entries(list, date), list}
  end 

end