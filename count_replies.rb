#!/usr/bin/env ruby

require "csv"

def main file
  CSV.table(file)
    .select(&IsReply)
    .group_by(&InReplyTo)
    .map(&CountUsers)
    .sort_by(&SortByCount)
    .take(10)
    .each(&Report)
end

IsReply = ->(tweet) { tweet[:text] =~ /^@\w/ }

InReplyTo = ->(reply) { reply[:text][/^@\w+/].downcase }

CountUsers = ->((user, replies)) { [user, replies.size] }

SortByCount = ->((_user, count)) { -count }

Report = ->((user, count)) { printf "%15s: %3i\n", user, count }

main "data/tweets.csv"
