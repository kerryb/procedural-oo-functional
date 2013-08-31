#!/usr/bin/env ruby

require "csv"

def main file
  CSV.table(file)
    .map {|row| Tweet.new row[:text] }
    .select(&:reply?)
    .group_by(&:in_reply_to)
    .map {|user, replies| Recipient.new user, replies.size }
    .sort
    .take(10)
    .each(&:report)
end

class Tweet
  def initialize text
    @text = text
  end

  def reply?
    @text =~ /^@\w/
  end

  def in_reply_to
    @text[/^@\w+/].downcase
  end
end

class Recipient
  attr_reader :number_of_replies

  def initialize name, number_of_replies
    @name = name
    @number_of_replies = number_of_replies
  end

  def <=> other
    other.number_of_replies <=> number_of_replies
  end

  def report
    printf "%15s: %3i\n", @name, @number_of_replies
  end
end

main "data/tweets.csv"
