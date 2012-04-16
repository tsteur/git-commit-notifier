# -*- coding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- vim:fenc=utf-8:filetype=ruby:et:sw=2:ts=2:sts=2

module GitCommitNotifier
  # Callback for Diff::LCS.traverse_balanced method.
  class DiffCallback
    # Gets collected tags.
    # @return [Array(Hash)] Collected tags.
    attr_reader :tags

    def initialize
      @tags = []
    end

    # Adds diff match to {#tags}.
    def match(event)
      @tags << { :action => :match, :token => event.old_element }
    end

    # Adds discarded B side to {#tags}.
    def discard_b(event)
      @tags << { :action => :discard_b, :token => event.new_element }
    end

    # Adds discarded A side to {#tags}.
    def discard_a(event)
      @tags << { :action => :discard_a, :token => event.old_element }
    end
  end
end

