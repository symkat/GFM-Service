module GFMService
  class HtmlWithAlbino < Redcarpet::Render::HTML
    def block_code(code, language)
      Albino.colorize(code, language)
    end
  end
end