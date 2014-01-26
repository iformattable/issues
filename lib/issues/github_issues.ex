defmodule Issues.GithubIssues do

  alias HTTPotion.Response

  @user_agent ["User-agent": "Elixir christopher316@gmail.com"]

  def fetch(user, project) do
    response = issues_url(user, project) |> HTTPotion.get @user_agent
    case response do
      Response[body: body, status_code: status, headers: _headers] when status in 200..299 ->
        {:ok, body}
      Response[body: body, status_code: _status, headers: _headers] ->
        {:error, body}
    end
  end

  defp issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

end
