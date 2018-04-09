require './app'

run App
map('/') { run App }
map('/users') { run App }
