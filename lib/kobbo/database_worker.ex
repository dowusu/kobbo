defmodule Kobbo.DatabaseWorker do
  use GenServer
  
  def start_link({worker_id, db_path}) do
    GenServer.start_link(__MODULE__, db_path, name: via_tuple(worker_id))
  end
  
  defp via_tuple(worker_id) do
    Kobbo.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end
  
  def store(worker_id, key, value) do
    GenServer.call(via_tuple(worker_id), {:store, key, value})
  end
  
  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end
  
  def init(db_path) do
    {:ok, db_path}
  end
  
  def handle_call({:store, key, value}, _from, db_path) do
    reply = 
      db_path
      |> filename(key)
      |> File.write(:erlang.term_to_binary(value))
      |> case do
        {:error, _} -> :error
          _ -> :ok
        end
    {:reply, reply, db_path}
  end 
  
  def handle_call({:get, key}, _from, db_path) do
   data = case File.read(filename(db_path, key)) do
    {:ok, binary} -> :erlang.binary_to_term(binary)
     _ -> nil
   end
   {:reply, data, db_path}
  end
  
  defp filename(folder, key) do
    Path.join([folder, to_string(key)])
  end
end