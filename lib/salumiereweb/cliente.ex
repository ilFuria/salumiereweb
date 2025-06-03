defmodule Cliente do
  use GenServer

  @topic_prefix "cliente:"

  defp topic(nome), do: @topic_prefix <> nome

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end

  def init(_) do
    {:ok, 0}
  end

  def accodati(name, numero) do
    GenServer.cast(via_tuple(name), {:accodati, numero, name})
  end

  def handle_cast({:accodati, numero, name}, _state) do
    notifica(numero, name)
    {:noreply, numero}
  end

  def handle_info({:avanti, nome}, stato) when stato > 1 do
    notifica(stato-1, nome)
    {:noreply, stato - 1}
  end

  def handle_info({:avanti, nome}, 1) do
    notifica(0,nome)
    SalumiereClientiRegistry.deregistra(nome)
    {:stop, :normal, 0}
  end

  defp via_tuple(name) do
    {:via, Registry, {Cliente.Registry, name}}
  end

def numero(nome) do
  GenServer.call(via_tuple(nome), :get)
end

def handle_call(:get, _from, stato) do
  {:reply, {:ok, stato}, stato}
end

  defp notifica(posizione, nome) do
 IO.inspect("Broadcast a #{topic(nome)} con #{posizione}")
   Phoenix.PubSub.broadcast(Salumiereweb.PubSub, topic(nome), {:aggiorna, posizione})
   end
end
