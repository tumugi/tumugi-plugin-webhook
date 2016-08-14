require_relative '../../test_helper'
require 'tumugi/plugin/target/webhook'

class Tumugi::Plugin::WebhookTargetTest < Test::Unit::TestCase
  test "exist? should return true if exists" do
    target = Tumugi::Plugin::WebhookTarget.new("value")
    assert_true(target.exist?)
  end
end
