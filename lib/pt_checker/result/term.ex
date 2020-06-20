defmodule PtChecker.Result.Term do
  use Ecto.Type

  def type, do: :binary

  def cast(binary) when is_binary(binary) do
    {:ok, :erlang.binary_to_term(binary)}
  end

  def cast(term) do
    {:ok, term}
  end

  def load(binary) do
    {:ok, :erlang.binary_to_term(binary)}
  end

  def dump(term) do
    {:ok, :erlang.term_to_binary(term)}
  end
end
