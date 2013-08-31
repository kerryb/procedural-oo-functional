#!/usr/bin/env ruby

require "csv"

def main file
  CSV.table(file)
    .select {|t| t[:text] =~ /^@\w/ }
    .group_by {|r| r[:text][/^@\w+/].downcase }
    .map {|u, r| [u, r.size] }
    .sort_by {|u, c| -c }
    .take(10)
    .each {|u,c| printf "%15s: %3i\n", u, c }
end

main "data/tweets.csv"
