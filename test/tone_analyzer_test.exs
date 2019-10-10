defmodule ToneAnalyzerTest do
  use ExUnit.Case

  alias ToneAnalyzer

  @path File.cwd!()

  describe "Tone Analyzer" do
    test "tone analyzer of a sentence" do
      payload = %{
        text:
          "Team, I know that times are tough! Product sales have been disappointing for the past three quarters. We have a competitive product, but we need to do a better job of selling it!",
        header: "Content-Type: plain/text"
      }

      assert {:ok, %{body: body}} = ToneAnalyzer.tone(:get, payload)

      assert {:ok,
              %{"document_tone" => %{"tones" => tones}, "sentences_tone" => list_of_sentences}} =
               Poison.decode(body)

      assert is_list(tones)
      assert is_list(list_of_sentences)
    end

    test "sending a binary JSON file to analyze the tone of the overall content" do
      file_path = Path.join([@path, "test/fixtures/tone.json"])
      assert true == File.exists?(file_path)
      file = File.read!(file_path)

      payload = %{
        file: file,
        header: {"Content-Type", "application/json"}
      }

      assert {:ok, %{body: body}} = ToneAnalyzer.tone(:post, payload)

      assert {:ok,
              %{"document_tone" => %{"tones" => tones}, "sentences_tone" => list_of_sentences}} =
               Poison.decode(body)

      assert is_list(tones)
      assert is_list(list_of_sentences)
    end

    test "analyze the tone of the overall content with sentences" do
      file_path = Path.join([@path, "test/fixtures/tone.json"])
      assert true == File.exists?(file_path)
      file = File.read!(file_path)

      payload = %{
        file: file,
        header: {"Content-Type", "application/json"}
      }

      assert {:ok, %{body: body}} = ToneAnalyzer.tone(:post, payload, true)
      assert {:ok, %{"document_tone" => %{"tones" => tones}}} = Poison.decode(body)
      assert is_list(tones)
    end

    test "analyze the tone of the overall content only without sentences" do
      file_path = Path.join([@path, "test/fixtures/tone.json"])
      assert true == File.exists?(file_path)
      file = File.read!(file_path)

      payload = %{
        file: file,
        header: {"Content-Type", "application/json"}
      }

      assert {:ok, %{body: body}} = ToneAnalyzer.tone(:post, payload, false)
      assert {:ok, %{"document_tone" => %{"tones" => tones}}} = Poison.decode(body)
      assert is_list(tones)
    end

    test "analyze the contents of the file as chat" do
      file_path = Path.join([@path, "test/fixtures/tone_chat.json"])
      assert true == File.exists?(file_path)
      file = File.read!(file_path)

      payload = %{
        file: file,
        header: {"Content-Type", "application/json"}
      }

      assert {:ok, %{body: body}} = ToneAnalyzer.tone_chat(payload)
      {:ok, %{"utterances_tone" => utterabces_list}} = Poison.decode(body)
      assert is_list(utterabces_list)
    end
  end
end
