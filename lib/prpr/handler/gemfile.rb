module Prpr
  module Handler
    class Gemfile < Base
      handle Event::PullRequest, action: /opened/ do
        Action::Gemfile::Update.new(event).call
      end
    end
  end
end
