defmodule PtChecker.MixProject do
  use Mix.Project

  def project do
    [
      app: :pt_checker,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:saxy, "~> 1.1"},
      {:httpoison, "~> 1.7"}
    ]
  end
end
