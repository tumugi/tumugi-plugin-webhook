task :main, type: :webhook do
  url "http://httpbin.org/post"
  body {
    { text: "message" }
  }
end
