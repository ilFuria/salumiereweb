defmodule SalumierewebWeb.SalumiereController do
  use SalumierewebWeb, :controller

  def new(conn, _params), do: render(conn, :new)

  def create(conn, %{"nome" => nome}) do
    case SalSupervisor.crea(nome) do
      _ -> redirect(conn, to: ~p"/salumieri/#{nome}")
    end
  end

  def show(conn, %{"nome" => nome}), do: render(conn, :show, nome: nome)
end
