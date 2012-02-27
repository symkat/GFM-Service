#!/usr/bin/env ruby
#require 'rubygems'
require 'rack'
require 'redcarpet'
require 'albino'
require 'json'

class HTMLwithAlbino < Redcarpet::Render::HTML
    def block_code(code, language)
        if language == nil
            return code
        end
        Albino.colorize(code, language)
    end
end

class GFMServer
  def fatal_error(msg)
    return [ 
      500, 
      { "Content-Type" => "application/json" },
      [ "{ 'status' : 0, 'error' : '#{msg}' }" ]
    ]
  end

  def get_markdown_class(input)
    return Redcarpet::Markdown.new(
      HTMLwithAlbino, 
      :no_intra_emphasis  => input['no_intra_emphasis']   ? true : false,
      :tables             => input['tables']              ? true : false, 
      :fenced_code_blocks => input['fenced_code_blocks']  ? true : false,
      :autolink           => input['autolink']            ? true : false, 
      :strikethrough      => input['strikethrough']       ? true : false,
      :lax_html_blocks    => input['lax_html_blocks']     ? true : false,
      :space_after_headers=> input['space_after_headers'] ? true : false,
      :superscript        => input['superscript']         ? true : false 
    )
  end

  def call(env)
    input = env['rack.input'].read

    if input.length == 0
      return fatal_error( "No JSON Structure as body" )
    end

    # Decode the JSON structure, or give an error.
    begin
      input = JSON.parse(input)
    rescue
      return fatal_error( "Invalid JSON Structure: #{input}" )
    end

    if input['document'].length == 0
        return fatal_error( "No content to markdown." ) 
    end

    # Get the markdown class based on JSON options
    # used.  TODO: is there a way to memoize this?
    markdown = get_markdown_class(input)

    content = [
    ]

    return [ 
      200, 
      { "Content-Type" => "application/json; charset=UTF-8" },
      [
        JSON.generate(
          "status" => 1,
          "document" => markdown.render( input['document'] )
        )
      ]
    ]
  end
end

