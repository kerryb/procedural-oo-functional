#!/usr/bin/env ruby

require "csv"

def main file
  CSV.table(file)
    .select(&reply?)
    .group_by(&in_reply_to)
    .map(&count_users)
    .sort_by(&sort_by_count)
    .take(10)
    .each(&report)
end

def reply?
  ->(tweet) { tweet[:text] =~ /^@\w/ }
end

def in_reply_to
  ->(reply) { reply[:text][/^@\w+/].downcase }
end

def count_users
  ->((user, replies)) { [user, replies.size] }
end

def sort_by_count
  ->((_user, count)) { -count }
end

def report
  ->((user, count)) { printf "%15s: %3i\n", user, count }
end

main "data/tweets.csv"
