module GFMService
  class MarkdownHandler < Mongrel::HttpHandler
    def process(request, response)

      # So, this is exception handling in Ruby aparently.
      begin
        input = JSON.parse(request.body.string)
      rescue
        response.start(500, true) do |header, body|
          header['Content-Type'] = "application/json"
          body << JSON.generate({"response" =>
                                     { "status" => 0,
                                       "error_message" => "Failed to decode JSON"
                                     }
                                })
        end
      end

      markdown = Redcarpet::Markdown.new(
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

      begin
        content = {
            "status" => "1",
            "document" => markdown.render(input['document'])
        }
      rescue
        content = {
            "status" => "0",
            "error_message" => "Failed to render markdown."
        }
      end

      to_json = {}
      to_json['request'] = input
      to_json['response'] = content

      begin
        output = JSON.generate(to_json)
      rescue
        output = JSON.generate({
                                   "response" => {
                                       "status" => "0",
                                       "error_message" => "Failed to encode JSON."
                                   }
                               })
      end

      response.start(200, true) do |header, body|
        header['Content-Type'] = "application/json"
        body << output
      end
    end
  end

end