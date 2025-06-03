defmodule SalumierewebWeb.SalumiereLive do
  use SalumierewebWeb, :live_view
  alias Salumiere

def mount(%{"nome" => nome}, _session, socket) do
  link = "/clienti/new?salumiere=#{nome}"

  socket =
    socket
    |> assign(:nome, nome)
    |> assign(:registration_link, link)

  {:ok, socket}
end

  def render(assigns) do
    ~H"""
    <h2>Salumiere: <%= @nome %></h2>
<p>
      Link per registrazione clienti:
      <a href={@registration_link}><%= @registration_link %></a>
    </p>
    <button phx-click="scoda">Scoda</button>
    """
  end

  def handle_event("scoda", _params, socket) do
    Salumiere.advance(socket.assigns.nome)
    {:noreply, socket}
  end
end
