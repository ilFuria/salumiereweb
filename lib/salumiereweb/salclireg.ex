defmodule SalumiereClientiRegistry do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def registra(cliente, nuovo_salumiere) do
    GenServer.cast(__MODULE__, {:registra, cliente, nuovo_salumiere})
  end

  def notifica(salumiere) do
    GenServer.cast(__MODULE__, {:notifica, salumiere})
  end

  def deregistra(cliente) do
    GenServer.cast(__MODULE__, {:deregistra, cliente})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:registra, cliente, nuovo_salumiere}, stato) do
    stato = Map.update(stato, nuovo_salumiere, MapSet.new([cliente]), &MapSet.put(&1, cliente))
    {:noreply, stato}
  end

  def handle_cast({:deregistra, cliente}, stato) do
    nuovo_stato =
      Enum.reduce(stato, %{}, fn {salumiere, set}, acc ->
        Map.put(acc, salumiere, MapSet.delete(set, cliente))
      end)

    {:noreply, nuovo_stato}
  end

  def handle_cast({:notifica, salumiere}, stato) do
    clienti = Map.get(stato, salumiere, MapSet.new())

    Enum.each(clienti, fn nome ->
      case Registry.lookup(Cliente.Registry, nome) do
        [{pid, _}] -> send(pid, {:avanti, nome})
        [] -> :ignore
      end
    end)

    {:noreply, stato}
  end
end
