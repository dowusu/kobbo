defmodule Kobbo.DatabaseWorker do
  use GenServer
  
  @db_path "./persist"
  
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end
  
  def store(key, value) do
    GenServer.call(__MODULE__, {:store, key, value})
  end
  
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end
  
  def init(_) do
    File.mkdir!(@db_path)
    {:ok, nil}
  end
  
  def handle_call({:store, key, value}, _from, state) do
    reply = 
      @db_path
      |> filename(key)
      |> File.write(:erlang.term_to_binary(value))
      |> case do
        {:error, _} -> :error
          _ -> :ok
        end
    {:reply, reply, state}
  end 
  
  def handle_call({:get, key}, _from, state) do
   data = case File.read(filename(@db_path, key)) do
    {:ok, binary} -> :erlang.binary_to_term(binary)
     _ -> nil
   end
   {:reply, data, state}
  end
  
  defp filename(folder, key) do
    Path.join([folder, to_string(key)])
  end
end