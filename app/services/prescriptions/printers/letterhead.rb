module Prescriptions
  module Printers
    # Draws the clinic letterhead as vectors and text instead of stamping a
    # 795 KB scan of it behind every prescription. The artwork was 7015x4960 px
    # (34.8 MP, ~600 DPI) and 94% blank, and accounted for 98% of every PDF.
    #
    # Coordinates are absolute page points, measured from that artwork: it was
    # drawn at background_scale 0.12, so image pixels map to points at x0.12.
    # Text is positioned by the baseline each row shared in the original.
    # rubocop:disable Metrics/ClassLength
    class Letterhead
      COLUMN_OFFSET = 419.5

      TITLE_COLOR = '1F3463'.freeze
      LABEL_COLOR = '082F72'.freeze
      ALERT_COLOR = 'D32C31'.freeze

      FONT = 'Montserrat'.freeze

      # Red, amber and violet thirds of the rule that brackets each column.
      # The lower rule is inset slightly more than the upper one, as in the
      # original artwork.
      BAR_COLORS = %w[E01E1F F5971B 813B91].freeze

      BARS = [
        { y: 497.8, height: 2.4, x: 9.6, width: 404.2 },
        { y: 11.9,  height: 2.0, x: 17.3, width: 394.9 }
      ].freeze

      IMAGES = "#{Rails.root}/app/assets/images".freeze
      LOGO   = "#{IMAGES}/orl-logo.png".freeze
      PHONE  = "#{IMAGES}/phone-glyph.png".freeze

      LOGO_AT      = [18.0, 579.0].freeze
      LOGO_WIDTH   = 69.6
      PHONE_AT     = [[177.0, 30.5], [696.7, 30.5]].freeze
      PHONE_WIDTH  = 9.5

      # Each row shares one baseline, given as the lowest ink in the original.
      # Where the row contains a descender the baseline sits above that.
      HEADING_ROWS = [
        { ink: 562.3, size: 16.8, descender: true,  color: TITLE_COLOR,
          items: [[128.9, 'Centro de especialidad en']] },
        { ink: 544.1, size: 16.9, descender: false, color: TITLE_COLOR,
          items: [[126.7, 'OTORRINOLARINGOLOGÍA']] },
        { ink: 529.7, size: 7.4,  descender: true,  color: TITLE_COLOR,
          items: [[108.0, 'Tratamiento Clínico y Quirúrgico'], [248.4, 'Citas:']] },
        { ink: 520.0, size: 6.8,  descender: true,  color: TITLE_COLOR,
          items: [[109.0, 'Oído, Nariz, Garganta, Cabeza y Cuello']] },
        { ink: 520.0, size: 7.4,  descender: true,  color: ALERT_COLOR,
          items: [[275.3, 'EMERGENCIAS:']] },
        { ink: 510.5, size: 7.5,  descender: true,  color: TITLE_COLOR,
          items: [[120.0, 'Atención Niños y Adultos']] }
      ].freeze

      LABEL_SIZE = 9.3

      # Absolute positions: the two columns are offset by ~420pt, but the
      # originals differ slightly per label, so each is kept as measured.
      LABEL_ROWS = [
        { ink: 483.0, descender: false, items: [[17.0, 'N°'], [437.4, 'N°']] },
        { ink: 466.6, descender: false, items: [[16.3, 'Paciente:'], [436.9, 'Paciente:']] },
        { ink: 448.1, descender: true,
          items: [[15.8, 'Diagnóstico CIE-10:'], [289.9, 'Edad:']] },
        { ink: 432.0, descender: true,  items: [[288.0, 'Alergias:']] },
        { ink: 413.2, descender: false, items: [[437.4, 'Indicaciones:']] },
        { ink: 170.8, descender: true,  size: 9.5, items: [[434.8, 'Signos de Alarma:']] },
        { ink: 118.9, descender: false, size: 9.5, items: [[435.5, 'Recomendaciones:']] },
        { ink: 38.4,  descender: false, items: [[435.7, 'Próxima Cita:']] }
      ].freeze

      def self.call(pdf)
        new(pdf).call
      end

      def initialize(pdf)
        @pdf = pdf
      end

      def call
        pdf.canvas do
          draw_bars
          draw_images
          draw_headings
          draw_labels
        end
      end

      private

      attr_reader :pdf

      def draw_bars
        BARS.each { |bar| draw_bar(bar) }
      end

      def draw_bar(bar)
        segment = bar[:width] / BAR_COLORS.size

        BAR_COLORS.each_with_index do |color, index|
          pdf.fill_color color
          draw_bar_segment(bar, bar[:x] + (segment * index), segment)
        end
      end

      def draw_bar_segment(bar, origin, width)
        each_column do |offset|
          pdf.fill_rectangle [origin + offset, bar[:y] + bar[:height]], width, bar[:height]
        end
      end

      def draw_images
        each_column do |offset|
          pdf.image LOGO, at: [LOGO_AT[0] + offset, LOGO_AT[1]], width: LOGO_WIDTH
        end

        PHONE_AT.each { |at| pdf.image PHONE, at: at, width: PHONE_WIDTH }
      end

      def draw_headings
        HEADING_ROWS.each do |row|
          row[:items].each do |origin, text|
            each_column { |offset| draw(text, origin + offset, row) }
          end
        end
      end

      def draw_labels
        LABEL_ROWS.each do |row|
          row[:items].each { |origin, text| draw(text, origin, row) }
        end
      end

      def draw(text, origin, row)
        pdf.font(FONT, style: :bold) do
          pdf.font_size(row.fetch(:size, LABEL_SIZE)) do
            pdf.fill_color row.fetch(:color, LABEL_COLOR)
            pdf.draw_text text, at: [origin, baseline(row)]
          end
        end
      end

      # The measured value is the lowest ink in the row, so on rows carrying a
      # descender the baseline sits above it.
      def baseline(row)
        row[:descender] ? row[:ink] + pdf.font.descender : row[:ink]
      end

      def each_column
        yield 0
        yield COLUMN_OFFSET
      end
    end
  end
end
