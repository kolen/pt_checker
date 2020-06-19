defmodule PtCheckerWeb.PageController do
  use PtCheckerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
