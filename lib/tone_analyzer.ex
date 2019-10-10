defmodule ToneAnalyzer do
  alias Tone

  @behaviour Tone

  @version Application.get_env(:ex_watson_tone, :version)
  @url Application.get_env(:ex_watson_tone, :url) <> "/v3/tone?version=#{@version}"
  @api_key Application.get_env(:ex_watson_tone, :api_key)

  @impl Tone
  def tone(:get, params) do
    content = "&" <> URI.encode_query(params)
    header = build_header()
    HTTPoison.get(@url <> content, header)
  end

  def tone(:post, %{file: data_binary}) do
    content = data_binary
    header = build_header()
    HTTPoison.post(@url, content, header)
  end

  @impl Tone
  def tone(:post, params, true), do: tone(:post, params)

  def tone(:post, %{file: data_binary}, false) do
    content = data_binary
    header = build_header()

    @url
    |> Kernel.<>("&sentences=false")
    |> HTTPoison.post(content, header)
  end

  @impl Tone
  def tone_chat(%{file: data_binary}) do
    content = data_binary
    header = build_header()

    @url
    |> String.replace("tone?", "tone_chat?")
    |> HTTPoison.post(content, header)
  end

  defp build_header do
    api_key = "apikey:#{@api_key}" |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key},
      {"Content-Type", "application/json"}
    ]
  end
end
