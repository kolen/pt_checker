defmodule PtCheckerWeb.RoutesController do
  use PtCheckerWeb, :controller

  def index(conn, _params) do
    routes = PtChecker.Routes.summary()
    render(conn, "index.html", routes: routes)
  end

  def show(conn, params) do
    route = PtChecker.Routes.route(params["id"])
    render(conn, "show.html", route: route, result: route.result)
  end
end
