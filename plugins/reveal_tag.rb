# Title: Simple Reveal presentation tag for Jekyll
# Author: Tyr Chen http://tchen.me
# Description: output embedd tag for reveal js presentation
#
# Syntax {% reveal url/to/presentation [width height] %}
#
# Example:
# {% reveal http://site.com/presentation.html 640 480 %}
#
# Output:
# <embed src="http://site.com/presentation.html" allowFullScreen="true" width="640" height="480" align="middle"></embed>
#

module Jekyll

  class RevealTag < Liquid::Tag
    @url = nil
    @height = ''
    @width = ''

    def initialize(tag_name, markup, tokens)
      if markup =~ /((https?:\/\/|\/)(\S+))(\s+(\d+)\s(\d+))?/i
        @url  = $1
        @width  = $5
        @height = $6
      end
      super
    end

    def render(context)
      output = super
      if @url
        reveal = "<embed src='#{@url}' allowFullScreen='true' width='#{@width}' height='#{@height}' align='middle'></embed>"
      else
        "Error processing input, expected syntax: {% reveal url/to/presentation [width height] %}"
      end
    end
  end
end

Liquid::Template.register_tag('reveal', Jekyll::RevealTag)

