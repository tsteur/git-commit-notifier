# -*- coding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*- vim:fenc=utf-8:filetype=ruby:et:sw=2:ts=2:sts=2

require "uri"
require "net/http"

class GitCommitNotifier::Webhook

  # Gets config.
  # @return [Hash] Configuration
  # @note Helper that represents class method in instance scope.
  # @see GitCommitNotifier::Webhook.config
  def config
    GitCommitNotifier::Webhook.config
  end

  def initialize(config, options = {})
    GitCommitNotifier::Webhook.config = config || {}
    %w[commiter message subject changed old_rev new_rev ref_name repo_name].each do |name|
      instance_variable_set("@#{name}".to_sym, options[name.to_sym])
    end
  end

  class << self

    def payload
      {
        repository: {
          name: @repo_name
        },
        ref: @ref_name,
        before: @old_rev,
        after: @new_rev,
        commits: [
          {
            added: [],
            modified: [],
            removed: [],
            author: {
              name: @commiter
            }
            message: @subject
          }
        ]
      }.to_json
    end

    def send
      Net::HTTP.post_form URI.parse(config.webhook.url) { payload: payload }
    end

  end

end
