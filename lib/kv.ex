defmodule KV do
  use Application

  @moduledoc """
  Documentation for `KV`.
  """

  @doc """
  Hello beren.

  ## Examples

      iex> KV.hello()
      :beren

  """
  def hello do
    :beren
  end

  @doc """
  Customize teh app startup logic with this
  """
  @impl true
  def start(_type, _args) do
    KV.Supervisor.start_link(name: KV.Supervisor)
  end
end
