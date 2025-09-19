#!/usr/bin/env ruby

# Test script to verify profile links functionality
require_relative 'config/environment'

puts "=== Profile Links Test ==="

# Check if routes are properly configured
puts "1. Checking routes..."
routes = Rails.application.routes.routes
profile_route = routes.find { |route| route.path.spec.to_s.include?('profile') && !route.path.spec.to_s.include?('users') }
user_profile_route = routes.find { |route| route.path.spec.to_s.include?('users') && route.path.spec.to_s.include?('profile') }

if profile_route
  puts "✓ Current user profile route exists: #{profile_route.verb} #{profile_route.path.spec}"
else
  puts "✗ Current user profile route not found"
end

if user_profile_route
  puts "✓ User profile route exists: #{user_profile_route.verb} #{user_profile_route.path.spec}"
else
  puts "✗ User profile route not found"
end

# Check if ProfilesController can handle user ID parameter
puts "\n2. Checking ProfilesController..."
if defined?(ProfilesController)
  puts "✓ ProfilesController exists"
  
  # Check controller code for ID parameter handling
  controller_file = Rails.root.join('app/controllers/profiles_controller.rb')
  if File.exist?(controller_file)
    controller_content = File.read(controller_file)
    if controller_content.include?('params[:id]')
      puts "✓ ProfilesController handles user ID parameter"
    else
      puts "✗ ProfilesController doesn't handle user ID parameter"
    end
  end
else
  puts "✗ ProfilesController not found"
end

# Check if _post partial has been updated with profile links
puts "\n3. Checking post partial..."
post_partial_path = Rails.root.join('app/views/posts/_post.html.erb')
if File.exist?(post_partial_path)
  partial_content = File.read(post_partial_path)
  if partial_content.include?('user_profile_path')
    puts "✓ Post partial includes user profile links"
  else
    puts "✗ Post partial missing user profile links"
  end
else
  puts "✗ Post partial not found"
end

# Test route helpers
puts "\n4. Testing route helpers..."
begin
  # Create a test user if needed for route testing
  test_user = User.first || User.create!(name: "Test User", email: "test@example.com", password: "password123")
  
  # Test user_profile_path helper
  user_profile_url = Rails.application.routes.url_helpers.user_profile_path(test_user)
  puts "✓ user_profile_path helper works: #{user_profile_url}"
  
  profile_url = Rails.application.routes.url_helpers.profile_path
  puts "✓ profile_path helper works: #{profile_url}"
rescue => e
  puts "✗ Route helper error: #{e.message}"
end

puts "\n=== Test Complete ==="
