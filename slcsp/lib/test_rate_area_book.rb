class TestRateAreaBook

	attr_accessor :area_rows


	def initialize array_of_area_rows
		@area_rows = array_of_area_rows
	end

	# Expected Row format is [zip_code, state, rate_area]
	def find_areas zip_code

		areas =[]
		@area_rows.each do |row|
			areas.push row[1,2] if row.first == zip_code

		end
		areas.size == 1 ? areas.first : nil

	end



end