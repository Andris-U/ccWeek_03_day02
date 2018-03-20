require('pg')
require('pry')
require_relative('models/bounty')

options1 = {
  'name' => 'Bork',
  'species' => 'Bark',
  'danger_level' => 'low',
  'collected_by' => 'Bopa Net'
}

options2 = {
  'name' => 'Xlligator Rex',
  'species' => 'Alligator-man?',
  'danger_level' => 'Like, dodgy af',
  'collected_by' => 'Steve IrvineX'
}

Bounty.delete_all

bounty1 = Bounty.new(options1)
bounty2 = Bounty.new(options2)

bounty1.save
bounty2.save

p Bounty.all
p Bounty.find_by_name("Bork")
p Bounty.find_by_id("2")
