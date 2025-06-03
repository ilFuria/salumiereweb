defmodule SalumierewebWeb.ClienteController do
  use SalumierewebWeb, :controller

  def new(conn, params) do
    render(conn, :new, salumiere: Map.get(params, "salumiere"))
  end

  def create(conn, %{"nome" => nome, "salumiere" => salumiere}) do
    case ClienteSupervisor.crea(nome, salumiere) do
      :ok ->
        redirect(conn, to: ~p"/clienti/#{nome}?salumiere=#{salumiere}")

      {:error, _} ->
        conn
        |> put_flash(:error, "Errore nella registrazione")
        |> redirect(to: ~p"/clienti/new?salumiere=#{salumiere}")
    end
  end
end
