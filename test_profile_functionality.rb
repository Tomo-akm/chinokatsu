#!/usr/bin/env ruby

# Test script to verify profile functionality
require_relative 'config/environment'

puts "=== Profile Functionality Test ==="

# Check if User model exists and has required associations
puts "1. Checking User model..."
if User.respond_to?(:new)
  puts "✓ User model exists"
  
  user = User.new
  if user.respond_to?(:posts)
    puts "✓ User has posts association"
  else
    puts "✗ User missing posts association"
  end
else
  puts "✗ User model not found"
end

# Check if ProfilesController exists
puts "\n2. Checking ProfilesController..."
if defined?(ProfilesController)
  puts "✓ ProfilesController exists"
  
  controller = ProfilesController.new
  if controller.respond_to?(:show)
    puts "✓ ProfilesController has show action"
  else
    puts "✗ ProfilesController missing show action"
  end
else
  puts "✗ ProfilesController not found"
end

# Check if profile view exists
puts "\n3. Checking profile view..."
profile_view_path = Rails.root.join('app/views/profiles/show.html.erb')
if File.exist?(profile_view_path)
  puts "✓ Profile view exists at #{profile_view_path}"
else
  puts "✗ Profile view not found"
end

# Check routes
puts "\n4. Checking routes..."
routes = Rails.application.routes.routes
profile_route = routes.find { |route| route.path.spec.to_s.include?('profile') }
if profile_route
  puts "✓ Profile route exists: #{profile_route.verb} #{profile_route.path.spec}"
else
  puts "✗ Profile route not found"
end

puts "\n=== Test Complete ==="
