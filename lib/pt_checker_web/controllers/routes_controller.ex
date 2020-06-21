defmodule PtCheckerWeb.RoutesController do
  use PtCheckerWeb, :controller

  def index(conn, _params) do
    routes = PtChecker.Routes.summary()
    render(conn, "index.html", routes: routes)
  end
end
