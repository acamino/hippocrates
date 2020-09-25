module Prescriptions
  module Printers
    class Section
      MARGIN = 5

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
      end

      def call
        pdf.font('Helvetica') do
          pdf.text_box content,
            at: at,
            width: width,
            **options
        end
      end

      private

      attr_reader :pdf, :content

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
