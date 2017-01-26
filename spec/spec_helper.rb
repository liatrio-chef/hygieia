require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.formatter = :documentation
  config.color     = true
  config.platform  = 'centos'
  config.version   = '6.8'
  config.log_level = :fatal
end

# get the list of spec files
specs = `ls spec/unit/recipes`
specs_arr = specs.split("\n")

# get the list of recipes
recipes = `ls recipes/`
recipes_arr = recipes.split("\n")

missing_arr = []

# check each recipe for a matching spec file
recipes_arr.each do |recipe|
  recipe = recipe.sub(/(.rb)/, '') << '_spec.rb'
  if specs_arr.include?(recipe)
  else
    missing_arr.push(recipe)
  end
end

# list all missing specs, and quit if there are any
unless missing_arr.empty?
  puts 'The following specfiles need to be implemented:'
  puts ''
  missing_arr.each do |missing|
    puts "    missing spec #{missing}"
  end
  puts ''
  exit(1)
end

at_exit { ChefSpec::Coverage.report! }
