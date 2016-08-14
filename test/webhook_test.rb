require_relative './test_helper'

class Tumugi::WebhookTest < Tumugi::Test::TumugiTestCase
  test 'run success' do
    assert_run_success("examples/example.rb", "main")
  end
end
