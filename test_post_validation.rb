#!/usr/bin/env ruby

# Script to reproduce the post validation error
puts "Testing post validation errors..."

# Simulate creating a post without user and content
require_relative 'config/environment'

# Test 1: Create post without user and content (should show validation errors)
puts "\n=== Test 1: Creating post without user and content ==="
post = Post.new
post.valid?

puts "Post errors:"
post.errors.full_messages.each do |error|
  puts "- #{error}"
end

# Test 2: Create post without content but with user
puts "\n=== Test 2: Creating post with user but without content ==="
user = User.first
if user
  post2 = Post.new(user: user)
  post2.valid?
  
  puts "Post errors:"
  post2.errors.full_messages.each do |error|
    puts "- #{error}"
  end
else
  puts "No user found in database"
end

puts "\nTesting complete."
