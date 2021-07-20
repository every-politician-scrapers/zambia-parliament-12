#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :id do
      noko.css('a/@href').text[/\/node\/(\d+)/, 1]
    end

    field :name do
      noko.css('.views-field-title .field-content').text.gsub(', MP', '').tidy
    end

    field :party do
      noko.css('.views-field-field-short-name .field-content').text.tidy
    end

    field :constituency do
      noko.css('.views-field-field-constituency-name .field-content').text.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      members_list.map { |mp| fragment(mp => Member).to_h }
    end

    private

    def members_list
      noko.css('.view-members-of-parliament .views-row')
    end
  end
end

urls = [
  'https://www.parliament.gov.zm/members/12-assembly',
  'https://www.parliament.gov.zm/members/12-assembly?page=1',
  'https://www.parliament.gov.zm/members/12-assembly?page=2',
  'https://www.parliament.gov.zm/members/12-assembly?page=3',
]

puts EveryPoliticianScraper::ScraperData.new(urls).csv
