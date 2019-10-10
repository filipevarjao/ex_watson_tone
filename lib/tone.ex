defmodule Tone do
  alias HTTPoison.{Response, Error}

  @callback tone(atom(), map()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, HTTPoison.Error.t()}
  @callback tone(atom(), map(), boolean()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, HTTPoison.Error.t()}
  @callback tone_chat(map()) :: {:ok, Response.t()} | {:error, Error.t()}
end
