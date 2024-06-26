defmodule Kobbo.List do
  defstruct next_id: 1, entries: %{}
  @opaque t :: %__MODULE__{next_id: non_neg_integer(), entries: map()}
  
  # def new() do
  #   %__MODULE__{}
  # end
  
  # def new(entries) do
  #   entries
  #   |> Enum.reduce(fn entry, %__MODULE__{} = list -> 
  #     new_entry = Map.put(entry, :id, list.next_id)
  #     %__MODULE__{list | entries: Map.put(list.entries, list.next_id, new_entry)}
  #     end)
  # end
  
  def new(entries \\ []) do
    entries
    |> Enum.reduce(%__MODULE__{},&add_entry(&2, &1))
  end
  
  def add_entry(%__MODULE__{} = list, %{} = entry) do
    entry = Map.put(entry, :id, list.next_id)
    %__MODULE__{list | entries: Map.put(list.entries, list.next_id, entry), 
      next_id: list.next_id + 1}
  end
  
  def entries(%__MODULE__{} = list, date) do
    list.entries
    |> Map.values()
    |> Enum.filter(&(&1.date == date))
  end
  
  def delete_entry(%__MODULE__{} = list, id) do
    entries = Map.delete(list.entries, id)
    %__MODULE__{list | entries: entries}
  end
  
  @spec update(t(), non_neg_integer(), (non_neg_integer() -> map())) :: t()
  def update(%__MODULE__{} = list, id, update_fun) do
    case Map.get(list.entries, id) do
     nil -> list
     entry ->
      new_entry = %{} = update_fun.(entry)
      %__MODULE__{list | entries: Map.put(list.entries, id, new_entry)}
    end
  end
end