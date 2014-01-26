defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [ app: :issues,
      version: "0.0.1",
      name: "Issues",
      source_url: "https://github.com/iformattable/issues",
      elixir: "~> 0.12.3-dev",
      escript_main_module: Issues.CLI,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Issues, [] },
      applications: [ :httpotion ]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      { :httpotion, github: "myfreeweb/httpotion" },
      { :jsx, github: "talentdeficit/jsx"},
      { :ex_doc, github: "elixir-lang/ex_doc" }
    ]
  end

end
