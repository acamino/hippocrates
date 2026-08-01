module Prescriptions
  module Printers
    class Section
      MARGIN = 5

      DEFAULT_FONT = 'Helvetica'.freeze

      # Helvetica is a PDF built-in, so Prawn encodes it to Windows-1252 and
      # raises on anything outside that set. Dropping the few unmappable
      # characters beats failing to print a prescription; Spanish accents are
      # part of Windows-1252 and survive untouched.
      PRINTABLE_ENCODING = 'Windows-1252'.freeze

      ENCODING_OPTIONS = {
        invalid: :replace,
        undef:   :replace,
        replace: ''
      }.freeze

      DEFAULT_OPTIONS = {
        align: :left,
        size: 9,
        inline_format: true
      }.freeze

      def self.call(pdf, at, width, content, options = {})
        new(pdf, at, width, content, options).call
      end

      def initialize(pdf, at, width, content, options)
        @pdf     = pdf
        @at      = at
        @width,  = width
        @content = content
        @options = options
        @font    = options.fetch(:font, DEFAULT_FONT)
      end

      def call
        pdf.font(@font) do
          pdf.fill_color @options.fetch(:color, '000000')
          pdf.text_box printable(content),
                       at: at,
                       width: width,
                       **options
        end
      end

      private

      attr_reader :pdf, :content

      def printable(text)
        text.to_s
            .encode(PRINTABLE_ENCODING, **ENCODING_OPTIONS)
            .encode(Encoding::UTF_8)
      end

      def options
        DEFAULT_OPTIONS.merge(@options)
      end

      def at
        [@at[0] + MARGIN, @at[1] - MARGIN]
      end

      def width
        @width - (MARGIN * 2)
      end
    end
  end
end
