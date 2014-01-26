defmodule Issues.CLI do
  @default_count 4
  @moduledoc """
  Handle the command line parsing and the dispatch to the
  various functions that end up generating a table of the
  last _n_ issues in a Github project
  """

  def main(argv) do 
    parse_args(argv) |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name and 
  (optionally) the number of entries to format.

  Return a tuple of `{user, project, count}`, or `:help`
  if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                      aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, binary_to_integer(count)}
      {_, [user, project], _}        -> {user, project, @default_count}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
      usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({user, project, c}) do
    Issues.GithubIssues.fetch(user, project) 
    |> decode_response
    |> Enum.map(&HashDict.new/1)
    |> Enum.sort(&(&1["number"] <= &2["number"]))
    |> Enum.take(c)
    |> Enum.each &(IO.puts %s[#{&1["number"]} | #{&1["created_at"]} | #{&1["title"]}])
  end

  def decode_response({:ok, body}), do: :jsx.decode body
  def decode_response({:error, msg}) do
    error = :jsx.decode msg
    IO.puts "Error fetching from Github: #{error}"
    System.halt(2)
  end

end
