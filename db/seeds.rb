# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Contest.destroy_all
Template.destroy_all
Template.create title: 'example', data: {
  areas_max_choice: 1,
  areas_attributes: [
    {
      code: 'a01',
      title: 'area one',
      profiles_max_choice: 1,
      profiles_attributes: [
        {
          code: 'p01',
          title: 'Profile one',
          careers_enabled: true,
          careers_requested: 12,
          qualifications_enabled: true,
          qualifications_requested: [],
          qualifications_alternative: [],
          sections_attributes: [
            {
              title: 'Section one', weight: 0
            },
            {
              title: 'Section two', weight: 0
            }
          ],
        }
      ]
    },{
      code: 'a02',
      title: 'area two',
      profiles_max_choice: 1,
      profiles_attributes: [
        {
          code: 'p01',
          title: 'Profile one',
          careers_enabled: true,
          careers_requested: 12,
          qualifications_enabled: true,
          qualifications_requested: [],
          qualifications_alternative: [],
          sections_attributes: [
            {
              title: 'Section one', weight: 0
            },
            {
              title: 'Section two', weight: 0
            }
          ],
        }
      ]

    }
  ]
}
2.times do 
  c = FactoryBot.create :contest, template_id: Template.first.id
end

