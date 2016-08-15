require_relative '../../test_helper'
require 'tumugi/plugin/task/webhook'
require 'tumugi/plugin/target/local_file'

class Tumugi::Plugin::WebhookTaskTest < Test::Unit::TestCase
  setup do
    @klass = Class.new(Tumugi::Plugin::WebhookTask)
  end

  test "default values" do
    @klass.set(:url, "http://example.com/test")
    task = @klass.new

    assert_equal("http://example.com/test", task.url)
    assert_equal("post", task.http_method)
    assert_equal(nil, task.body)
    assert_equal("json", task.body_encoding)
  end

  test "should set correctly" do
    @klass.set(:url, "http://example.com/test")
    @klass.set(:http_method, "put")
    @klass.set(:body, "key=val")
    @klass.set(:body_encoding, "url_encoded")
    task = @klass.new

    task = @klass.new
    assert_equal("http://example.com/test", task.url)
    assert_equal("put", task.http_method)
    assert_equal("key=val", task.body)
    assert_equal("url_encoded", task.body_encoding)
  end

  sub_test_case "#run" do
    data({
      get:    { method: "get", body: JSON.generate(a: "b")},
      post:   { method: "post", body: JSON.generate(a: "b")},
      put:    { method: "put", body: JSON.generate(a: "b")},
      delete: { method: "delete", body: JSON.generate(a: "b")},
    })
    test "http method" do |data|
      @klass.set(:url, "http://httpbin.org/#{data[:method]}")
      @klass.set(:http_method, data[:method])
      @klass.set(:body, data[:body])
      @klass.instance_eval {
        tf = Tempfile.create("test")
        define_method(:output) do
          Tumugi::Plugin::LocalFileTarget.new(tf.path)
        end
      }
      task = @klass.new

      task.run

      output = ""
      task.output.open("r") do |fp|
        output = JSON.parse(fp.read)
      end

      assert_equal("http://httpbin.org/#{data[:method]}", output["url"])
      if ["get", "delete"].include?(data[:method])
        assert_nil(output["json"])
      else
        assert_equal("application/json", output["headers"]["Content-Type"])
        assert_equal(JSON.parse(data[:body]), output["json"])
      end
    end

    test "follow redirect" do
      @klass.set(:url, "http://httpbin.org/redirect/2")
      @klass.set(:http_method, "get")
      @klass.instance_eval {
        tf = Tempfile.create("test")
        define_method(:output) do
          Tumugi::Plugin::LocalFileTarget.new(tf.path)
        end
      }
      task = @klass.new

      task.run

      output = ""
      task.output.open("r") do |fp|
        output = JSON.parse(fp.read)
      end
      assert_equal("http://httpbin.org/get", output["url"])
    end

    test "raise error when cannot connect" do
      @klass.set(:url, "http://localhost:55555/test")
      @klass.instance_eval {
        define_method(:output) do
          Tumugi::Plugin::LocalFileTarget.new(f.path)
        end
      }

      task = @klass.new

      assert_raise(Tumugi::TumugiError) do
        task.run
      end
    end

    test "raise error when response status is not success" do
      @klass.set(:url, "http://httpbin.org/status/500")
      task = @klass.new

      assert_raise(Tumugi::TumugiError) do
        task.run
      end
    end
  end
end
