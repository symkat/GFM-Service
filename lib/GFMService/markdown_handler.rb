module GFMService
  class MarkdownHandler < Mongrel::HttpHandler

    MSG_FAILED_TO_RENDER_MDOWN = {
        "status" => "0",
        "error_message" => "Failed to render markdown."
    }
    MSG_FAILED_TO_DECODE_JSON = JSON.generate({
        "response" =>
            {"status" => 0,
             "error_message" => "Failed to decode JSON"
            }
    })
    MSG_FAILED_TO_ENCODE_JSON = JSON.generate({
        "response" => {
            "status" => "0",
            "error_message" => "Failed to encode JSON."
        }
    })

    def process(request, response)
      input = JSON.parse(request.body.string)
      markdown = my_custom_markdown(input)

      begin
        content = {"status" => "1",
                   "document" => markdown.render(input['document'])
        }
      rescue
        content = MSG_FAILED_TO_RENDER_MDOWN
      end

      output = JSON.generate({'request' => input, 'response' => content})
      send_back(response, 200, output)

    rescue JSON::ParserError => e
      send_back(response, 500, MSG_FAILED_TO_DECODE_JSON)
    rescue JSON::GenerateError => e
      send_back(response, 200, MSG_FAILED_TO_ENCODE_JSON)

    end

    #private

    def send_back(response, response_code, message)
      response.start(response_code, true) do |header, body|
        header['Content-Type'] = "application/json"
        body << message
      end
    end

    def my_custom_markdown input
      Redcarpet::Markdown.new(
          HtmlWithAlbino,
          :no_intra_emphasis => input['no_intra_emphasis'] ? true : false,
          :tables => input['tables'] ? true : false,
          :fenced_code_blocks => input['fenced_code_blocks'] ? true : false,
          :autolink => input['autolink'] ? true : false,
          :strikethrough => input['strikethrough'] ? true : false,
          :lax_html_blocks => input['lax_html_blocks'] ? true : false,
          :space_after_headers=> input['space_after_headers'] ? true : false,
          :superscript => input['superscript'] ? true : false
      )
    end

  end

end