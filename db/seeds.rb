# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

filepath = "db/experts.csv"

puts "Creating the experts"

CSV.foreach(filepath, headers: :first_row) do |row|
  expert = Expert.new(
    name: row['name'],
    city: row['city'],
    score_a: row['score_a'],
    score_b: row['score_b'],
    score_c: row['score_c'],
    nb_sales: row['nb_sales']
  )
  expert.save!
end

puts "Creating experts done"
