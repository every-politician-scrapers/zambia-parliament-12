#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/wikidata_query'

query = <<SPARQL
  SELECT (STRAFTER(STR(?member), STR(wd:)) AS ?item) ?name ?party ?constituency
  WHERE {
    ?member p:P39 ?ps .
    ?ps ps:P39 wd:Q18607856 ; pq:P2937 wd:Q45380990 .
    # FILTER NOT EXISTS { ?ps pq:P582 ?end }

    OPTIONAL {
      ?ps pq:P4100 ?faction
      OPTIONAL { ?faction rdfs:label ?party FILTER(LANG(?party) = "en") }
    }

    OPTIONAL {
      ?ps pq:P768 ?district
      OPTIONAL { ?district rdfs:label ?constituency FILTER(LANG(?constituency) = "en") }
    }

    OPTIONAL { ?ps prov:wasDerivedFrom/pr:P1810 ?p39Name }
    OPTIONAL { ?member rdfs:label ?enLabel FILTER(LANG(?enLabel) = "en") }
    BIND(COALESCE(?p39Name, ?enLabel) AS ?name)
  }
  ORDER BY ?name
SPARQL

agent = 'every-politican-scrapers/zambia-parliament-12'
puts EveryPoliticianScraper::WikidataQuery.new(query, agent).csv
