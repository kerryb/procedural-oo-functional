#!/usr/bin/env ruby

require "csv"

def main file
  tweets = CSV.table file
  replies = select_replies tweets
  grouped_replies = group_replies replies
  user_counts = count_users grouped_replies
  sorted_user_counts = sort_user_counts user_counts
  top_ten_users = get_top_ten sorted_user_counts
  report top_ten_users
end

private

def select_replies tweets
  tweets.select {|t| t[:text] =~ /^@\w/ }
end

def group_replies replies
  replies.group_by {|r| r[:text][/^@\w+/].downcase }
end

def count_users grouped_replies
  grouped_replies.map {|u, r| [u, r.size] }
end

def sort_user_counts user_counts
  user_counts.sort_by {|u, c| -c }
end

def get_top_ten user_counts
  user_counts.take 10
end

def report users
  users.each {|u,c| printf "%15s: %3i\n", u, c }
end

main "data/tweets.csv"
