require 'nokogiri'

module Canvas
  module Workflow
    module Filters
      module InlineColorFilter
        CSS = {
          vb: {
            c:   'color: #008000',            # Comment
            err: 'border: 1px solid #FF0000', # Error
            k:   'color: #0000ff',            # Keyword
            ch:  'color: #008000',            # Comment.Hashbang
            cm:  'color: #008000',            # Comment.Multiline
            cp:  'color: #0000ff',            # Comment.Preproc
            cpf: 'color: #008000',            # Comment.PreprocFile
            c1:  'color: #008000',            # Comment.Single
            cs:  'color: #008000',            # Comment.Special
            ge:  'font-style: italic',        # Generic.Emph
            gh:  'font-weight: bold',         # Generic.Heading
            gp:  'font-weight: bold',         # Generic.Prompt
            gs:  'font-weight: bold',         # Generic.Strong
            gu:  'font-weight: bold',         # Generic.Subheading
            kc:  'color: #0000ff',            # Keyword.Constant
            kd:  'color: #0000ff',            # Keyword.Declaration
            kn:  'color: #0000ff',            # Keyword.Namespace
            kp:  'color: #0000ff',            # Keyword.Pseudo
            kr:  'color: #0000ff',            # Keyword.Reserved
            kt:  'color: #2b91af',            # Keyword.Type
            s:   'color: #a31515',            # Literal.String
            nc:  'color: #2b91af',            # Name.Class
            ow:  'color: #0000ff',            # Operator.Word
            sa:  'color: #a31515',            # Literal.String.Affix
            sb:  'color: #a31515',            # Literal.String.Backtick
            sc:  'color: #a31515',            # Literal.String.Char
            dl:  'color: #a31515',            # Literal.String.Delimiter
            sd:  'color: #a31515',            # Literal.String.Doc
            s2:  'color: #a31515',            # Literal.String.Double
            se:  'color: #a31515',            # Literal.String.Escape
            sh:  'color: #a31515',            # Literal.String.Heredoc
            si:  'color: #a31515',            # Literal.String.Interpol
            sx:  'color: #a31515',            # Literal.String.Other
            sr:  'color: #a31515',            # Literal.String.Regex
            s1:  'color: #a31515',            # Literal.String.Single
            ss:  'color: #a31515'             # Literal.String.Symbol
          }
        }.freeze

        def inline_color(raw, lang = 'vb')
          doc = Nokogiri::HTML.fragment(raw.encode('UTF-8', :invalid => :replace, :undef => :replace, :replace => ''))

          inline = CSS[lang.to_sym]

          # convert class to inline color
          doc.search("div.language-#{lang} div.highlight span").each do |span|
            span['style'] = inline[span['class'].to_sym]
          end
          # remove extra whitespace in pre blocks
          doc.search("div.language-#{lang} div.highlight pre").each do |pre|
            pre.inner_html = pre.inner_html.gsub(/(\R)    /, '\1')
          end

          doc.inner_html
        end
      end
    end
  end
end

Liquid::Template.register_filter(Canvas::Workflow::Filters::InlineColorFilter)
