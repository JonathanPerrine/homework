require 'rspec/core/rake_task'
require './lib/slcsp'

task :run_tests do
	RSpec::Core::RakeTask.new(:spec)
	Rake::Task["spec"].execute
end

task :calculate_slcsp do
	ruby "lib/slcsp.rb"
	@slcsp = Slcsp.new()
	puts "Building Rate Area Book"
	@slcsp.build_rate_area_book_from_file("./zips.csv")
	puts "Building Plan Book"
	@slcsp.build_plan_book_from_file("./plans.csv")
	puts "Reading Zip Codes"
	zipcodes = @slcsp.gather_zipcodes_from_file("./slcsp.csv")
	puts "Calculating SLCSP Rates"
	rate_rows = @slcsp.find_SLCSP_for_zip_codes zipcodes
	puts "Building SLCSP csv output"
	@slcsp.add_slcsp_rate_to_file("./slcsp.csv", rate_rows)

end

task :default => :run_tests

