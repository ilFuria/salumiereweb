defmodule SalumierewebWeb.ClienteLive do
  use Phoenix.LiveView

  alias Salumiere
  alias Cliente

  @impl true
  def mount(%{"nome" => cliente, "salumiere" => salumiere}, _session, socket) do
    # Sottoscrivi per ricevere aggiornamenti
    numero=
    case Cliente.numero(cliente) do
    {:ok, n} -> n
    _ ->0
    end
    Phoenix.PubSub.subscribe(Salumiereweb.PubSub, "cliente:" <> cliente)
IO.inspect("Sottoscritto a: cliente:" <> cliente)
  socket=
  socket
  |> assign(:nome, cliente)
  |> assign(:salumiere, salumiere)
  |> assign(:numero, numero)
  {:ok, socket}
  end

  @impl true
  def handle_info({:aggiorna, nuovo_numero}, socket) do
    {:noreply, assign(socket, numero: nuovo_numero)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2>Cliente: {@nome}</h2>
    <p>Numero attuale: {@numero}</p>
    """
  end
end
