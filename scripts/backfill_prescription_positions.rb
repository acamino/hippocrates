# frozen_string_literal: true

# Backfills the `position` column on prescriptions based on id order
# within each consultation.
#
# Usage:
#   ruby scripts/backfill_prescription_positions.rb DATABASE_URL [options]
#
# Options:
#   --dry-run   Show what would be updated without making changes
#   --limit N   Only process the first N consultations (useful for testing)
#
# Examples:
#   ruby scripts/backfill_prescription_positions.rb \
#     postgres://user:pass@host/db --dry-run --limit 10
#   ruby scripts/backfill_prescription_positions.rb postgres://user:pass@host/db

require 'pg'
require 'optparse'

database_url = ARGV.shift
abort "Usage: ruby #{$PROGRAM_NAME} DATABASE_URL [--dry-run] [--limit N]" unless database_url

dry_run = false
limit = nil

parser = OptionParser.new do |opts|
  opts.on('--dry-run') { dry_run = true }
  opts.on('--limit N', Integer) { |n| limit = n }
end
parser.parse!(ARGV)

conn = PG.connect(database_url)

puts dry_run ? '=== DRY RUN ===' : '=== LIVE RUN ==='

# Find consultations that have prescriptions
consultation_query = <<~SQL
  SELECT DISTINCT consultation_id
  FROM prescriptions
  ORDER BY consultation_id
SQL
consultation_query += " LIMIT #{limit}" if limit

consultations = conn.exec(consultation_query)
total = consultations.ntuples
puts "Found #{total} consultations with prescriptions"

updated = 0

consultations.each_with_index do |row, i|
  consultation_id = row['consultation_id']

  prescriptions = conn.exec_params(
    'SELECT id, position FROM prescriptions WHERE consultation_id = $1 ORDER BY id',
    [consultation_id]
  )

  prescriptions.each_with_index do |rx, pos|
    current_position = rx['position'].to_i
    next if current_position == pos

    if dry_run
      puts "  [dry-run] prescription #{rx['id']}: position #{current_position} -> #{pos}"
    else
      conn.exec_params(
        'UPDATE prescriptions SET position = $1 WHERE id = $2',
        [pos, rx['id']]
      )
    end
    updated += 1
  end

  if ((i + 1) % 100).zero? || i + 1 == total
    print "\r  Processed #{i + 1}/#{total} consultations..."
  end
end

puts
puts "#{dry_run ? 'Would update' : 'Updated'} #{updated} prescriptions"
conn.close
