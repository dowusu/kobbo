defmodule Kobbo.Server do
  use GenServer
  alias Kobbo.List
  def start_link(todo_name) do
    GenServer.start_link(__MODULE__, todo_name, name: via_tuple(todo_name))
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
  
  def init(todo_name) do
    {:ok, {List.new(), todo_name}}
  end
  
  def handle_call({:add_entry, entry}, _from, {list, todo_name}) do
    new_list = List.add_entry(list, entry)
    Kobbo.Database.store(todo_name, new_list)
    {:reply, :ok, {new_list, todo_name}}
  end
  
  def handle_call({:entries, date}, _from, {list, todo_name}) do
    {:reply, List.entries(list, date), {list, todo_name}}
  end 

end