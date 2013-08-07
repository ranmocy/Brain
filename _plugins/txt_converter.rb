module Jekyll
  module Converters
    class Txt < Converter
      safe true

      # pygments_prefix '<notextile>'
      # pygments_suffix '</notextile>'

      def matches(ext)
        ext =~ Regexp.new('txt', Regexp::IGNORECASE)
      end

      def output_ext(ext)
        ".html"
      end

      def convert(content)
        <<-HTML
<pre>
#{content}
</pre>
        HTML
      end
    end
  end
end
