defmodule Tone do
  alias HTTPoison.{Response, Error}

  @callback tone(map()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, HTTPoison.Error.t()}
  @callback tone(map(), list()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, HTTPoison.Error.t()}
  @callback tone_chat(map()) :: {:ok, Response.t()} | {:error, Error.t()}
end
