#!/usr/bin/env ruby

require_relative 'lib/slack-required'

@sr = SlackRequired.new('test/config.cfg')

@search_write = @sr.SearchandWrite
