#!/usr/bin/env ruby

# Script to test complete post creation functionality
puts "Testing post creation functionality..."

require_relative 'config/environment'

# Test creating a valid post
puts "\n=== Test: Creating a valid post ==="
user = User.first
if user
  post = Post.new(content: "テスト投稿です", user: user)
  
  if post.valid?
    puts "✓ Post validation passed"
    if post.save
      puts "✓ Post saved successfully"
      puts "  Post ID: #{post.id}"
      puts "  Content: #{post.content}"
      puts "  User: #{post.user.name}"
      puts "  Created at: #{post.created_at}"
    else
      puts "✗ Failed to save post"
    end
  else
    puts "✗ Post validation failed:"
    post.errors.full_messages.each do |error|
      puts "  - #{error}"
    end
  end
else
  puts "✗ No user found in database"
end

# Test creating post with empty content (should fail with Japanese message)
puts "\n=== Test: Creating post with empty content ==="
if user
  post2 = Post.new(content: "", user: user)
  
  if post2.valid?
    puts "✗ Post validation passed (should have failed)"
  else
    puts "✓ Post validation failed as expected:"
    post2.errors.full_messages.each do |error|
      puts "  - #{error}"
    end
  end
end

puts "\nTesting complete."
