#!/usr/bin/env ruby

require "csv"

def main file
  tweets = CSV.table file
  replies = tweets.select {|t| t[:text] =~ /^@\w/ }
  grouped_replies = replies.group_by {|r| r[:text][/^@\w+/].downcase }
  user_counts = *grouped_replies.map {|u, r| [u, r.size] }
  sorted_user_counts = user_counts.sort_by {|u, c| -c }
  top_ten_users = sorted_user_counts.take 10
  top_ten_users.each {|u,c| printf "%15s: %3i\n", u, c }
end

main "data/tweets.csv"
