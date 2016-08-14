task :main, type: :webhook do
  param1 'value1'
  output { target(:webhook, param1) }
end
