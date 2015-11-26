defmodule Issues.GithubIssues do
	
	require Logger
	
	@user_agent [ { "User-agent", "Elixir samuel.dost@gmail.com" } ]
	@github_url Application.get_env(:issues, :github_url)
	
	def fetch(user, project) do
		Logger.info "Fetching user #{user}'s project #{project}"
		issues_url(user, project)
		|> HTTPoison.get(@user_agent)
		|> handle_response
	end
	
	def issues_url(user, project) do
		"#{@github_url}/repos/#{user}/#{project}/issues"
	end
	
	def handle_response({ :ok, %HTTPoison.Response{body: body, headers: _} }) do
		Logger.info "Successful response"
	 	{ :ok, :jsx.decode(body) }
	end
		 
	def handle_response({ :error, %HTTPoison.Error{id: _, reason: reason} }) do
		Logger.info "Error #{reason} returned"
		{ :error, reason }
	end
end