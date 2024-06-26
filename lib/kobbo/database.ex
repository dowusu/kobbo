defmodule Kobbo.Database do
  use Supervisor
  @pool_size 3
  @db_path "./persist"
  
  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end
  
  def init(_) do
    File.mkdir_p!(@db_path)
    children = Enum.map(1..@pool_size, &worker_spec/1)
    Supervisor.init(children, strategy: :one_for_one)
  end
  
  defp worker_spec(worker_id) do
    Supervisor.child_spec(Kobbo.DatabaseWorker, 
      id: {Kobbo.DatabaseWorker, worker_id},
      start: {Kobbo.DatabaseWorker, :start_link, [{worker_id, @db_path}]}
    )
  end
  
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end
end