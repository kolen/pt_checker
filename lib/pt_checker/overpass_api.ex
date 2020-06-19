defmodule PtChecker.OverpassAPI do
  def query(query) do
    HTTPoison.start()

    {:ok, response} =
      HTTPoison.request(
        :post,
        endpoint(),
        {:form, [{:data, query}]}
      )

    %HTTPoison.Response{status_code: 200, body: body} = response
    body
  end

  defp endpoint do
    "http://overpass-api.de/api/interpreter"
  end
end
