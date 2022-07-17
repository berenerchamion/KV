defmodule KV.Registry do
  use GenServer

  @moduledoc """
  A GenServer to manage the keys
  """

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `{:error, reason}` otherwise.
  """

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name`
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Defining GenServer Callbacks

  @doc """
  Custom init function
  """
  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @doc """
  Handling the call for looking up a key/value pair
  """
  @impl true
  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  @doc """
  Handling the cast (async) and persisting the key value pair
  """
  @impl true
  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = KV.Bucket.start_link([])
      {:noreply, Map.put(names, name, bucket)}
    end
  end
end
