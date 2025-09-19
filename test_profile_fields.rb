#!/usr/bin/env ruby

# Test script to verify profile fields functionality
require_relative 'config/environment'

puts "=== Profile Fields Test ==="

# Check if User model has the new profile fields
puts "1. Checking User model attributes..."
user = User.new
profile_fields = [:favorite_language, :research_lab, :internship_count, :personal_message]

profile_fields.each do |field|
  if user.respond_to?(field)
    puts "✓ User has #{field} attribute"
  else
    puts "✗ User missing #{field} attribute"
  end
end

# Check if validations work
puts "\n2. Testing validations..."
user = User.new(name: "Test User", email: "test@example.com", password: "password123")
user.internship_count = -1
if user.valid?
  puts "✗ Validation failed - should reject negative internship_count"
else
  puts "✓ Validation correctly rejects negative internship_count"
end

user.internship_count = 5
if user.valid?
  puts "✓ Validation accepts valid internship_count"
else
  puts "✗ Validation incorrectly rejects valid internship_count"
end

# Check if ProfilesController has new methods
puts "\n3. Checking ProfilesController methods..."
controller = ProfilesController.new
if controller.respond_to?(:edit)
  puts "✓ ProfilesController has edit action"
else
  puts "✗ ProfilesController missing edit action"
end

if controller.respond_to?(:update)
  puts "✓ ProfilesController has update action"
else
  puts "✗ ProfilesController missing update action"
end

# Check if edit view exists
puts "\n4. Checking edit profile view..."
edit_view_path = Rails.root.join('app/views/profiles/edit.html.erb')
if File.exist?(edit_view_path)
  puts "✓ Edit profile view exists"
  
  # Check if the view contains form fields for new attributes
  view_content = File.read(edit_view_path)
  profile_fields.each do |field|
    if view_content.include?(field.to_s)
      puts "✓ Edit view contains #{field} field"
    else
      puts "✗ Edit view missing #{field} field"
    end
  end
else
  puts "✗ Edit profile view not found"
end

# Check routes
puts "\n5. Checking routes..."
routes = Rails.application.routes.routes
edit_route = routes.find { |route| route.path.spec.to_s.include?('profile/edit') }
update_route = routes.find { |route| route.path.spec.to_s.include?('profile') && route.verb == 'PATCH' }

if edit_route
  puts "✓ Edit profile route exists: #{edit_route.verb} #{edit_route.path.spec}"
else
  puts "✗ Edit profile route not found"
end

if update_route
  puts "✓ Update profile route exists: #{update_route.verb} #{update_route.path.spec}"
else
  puts "✗ Update profile route not found"
end

# Check if show view displays new fields
puts "\n6. Checking show profile view..."
show_view_path = Rails.root.join('app/views/profiles/show.html.erb')
if File.exist?(show_view_path)
  show_content = File.read(show_view_path)
  profile_fields.each do |field|
    if show_content.include?(field.to_s)
      puts "✓ Show view displays #{field}"
    else
      puts "✗ Show view missing #{field} display"
    end
  end
else
  puts "✗ Show profile view not found"
end

puts "\n=== Test Complete ==="
