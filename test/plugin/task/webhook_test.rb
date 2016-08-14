require_relative '../../test_helper'
require 'tumugi/plugin/task/webhook'

class Tumugi::Plugin::WebhookTaskTest < Test::Unit::TestCase
  setup do
    @klass = Class.new(Tumugi::Plugin::WebhookTask)
    @klass.set(:param1, "value")
  end

  test "should set correctly" do
    task = @klass.new
    assert_equal("value", task.param1)
  end

  test "#output" do
    task = @klass.new
    output = task.output
    assert_true(output.is_a? Tumugi::Plugin::WebhookTarget)
  end

  test "#run" do
    task = @klass.new
    output = task.output
    task.run
    assert_equal("value", output.value)
  end
end
