defmodule ToneAnalyzer do
  alias Tone

  @behaviour Tone

  @version Application.get_env(:ex_watson_tone, :version)
  @url Application.get_env(:ex_watson_tone, :url)
  @api_key Application.get_env(:ex_watson_tone, :api_key)

  @json_header {"Content-Type", "application/json"}

  @impl Tone
  def tone(%{text: _text} = content) do
    content = URI.encode_query(content)
    header = build_header()

    "#{@url}/v3/tone?version=#{@version}&#{content}"
    |> HTTPoison.get(header)
  end

  def tone(%{file: data_binary}) do
    header = build_header()

    "#{@url}/v3/tone?version=#{@version}"
    |> HTTPoison.post(data_binary, header)
  end

  @impl Tone
  def tone(params, sentences: true), do: tone(params)

  def tone(%{file: data_binary}, sentences: false) do
    header = build_header()

    "#{@url}/v3/tone?version=#{@version}&sentences=false"
    |> HTTPoison.post(data_binary, header)
  end

  @impl Tone
  def tone_chat(%{file: data_binary}) do
    header = build_header()

    "#{@url}/v3/tone_chat?version=#{@version}"
    |> HTTPoison.post(data_binary, header)
  end

  defp build_header do
    api_key = "apikey:#{@api_key}" |> Base.encode64()

    [
      {"Authorization", "Basic " <> api_key},
      @json_header
    ]
  end
end
