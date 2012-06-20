require "uri"
require "net/http"

class GitCommitNotifier::Webhook

  def initialize(config, options = {})
    GitCommitNotifier::Emailer.config = config || {}
    @payload = {
      "repository" => {
        "name" => ""
      },
      "ref" => "",
      "before" => "",
      "after" => "",
      "commits" => [
        {
          "added" => [],
          "modified" => [],
          "removed" => [],
          "author" => {
            "name" => "",
            "email" => "",
          }
          "timestamp" => "",
          "id" => "",
          "message" => ""
        }
      ]
    }
  end

  class << self

    def send
      params = {'payload' => JSON.}
    end

  end

end
