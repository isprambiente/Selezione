# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Contest.destroy_all
2.times do 
  c = FactoryBot.create :contest
  2.times do
    a = FactoryBot.create :area, contest: c
    2.times { FactoryBot.create :profile, area: a }
  end
end
2.times do 
  c = FactoryBot.create :contest_future
  2.times do
    a = FactoryBot.create :area, contest: c
    2.times { FactoryBot.create :profile, area: a }
  end
end
2.times do 
  c = FactoryBot.create :contest_ended
  2.times do
    a = FactoryBot.create :area, contest: c
    2.times { FactoryBot.create :profile, area: a }
  end
end

