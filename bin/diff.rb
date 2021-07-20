#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

# Process the data from each source before comparison
class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    # remove anything in brackets (usually constituencies)
    { converters: [->(val) { val.to_s.gsub(/ \(.*?\)/, '').gsub('independent politician', 'Independent') }] }
  end

  def external_csv_options
    # remove anything in brackets (usually Party shortnames)
    { converters: [->(val) { val.to_s.gsub(/ \(.*?\)/, '').gsub('Nominated', '').gsub('Not Applicable', '') }] }
  end
end

diff = Comparison.new('data/wikidata.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1]] }.reverse.map(&:to_csv)
