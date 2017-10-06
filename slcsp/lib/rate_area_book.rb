class RateAreaBook

	attr_accessor :rate_area_rows


	def initialize rate_area_filename
		rate_area_rows = []
		# Expected Row format is [zip_code, state, rate_area]
		CSV.foreach(rate_area_filename, :headers => true) do |rate_row|
			rate_area = []
			rate_area[0] = rate_row['zipcode']
			rate_area[1] = rate_row['state']
			rate_area[2] = rate_row['rate_area']
			rate_area_rows.push rate_area
		end
		@rate_area_rows = rate_area_rows.uniq
	end

	# Expected Row format is [zip_code, state, rate_area]
	def find_areas zip_code
		areas =[]
		@rate_area_rows.each do |row|
			areas.push row[1,2] if row.first == zip_code

		end
		areas.size == 1 ? areas.first : nil

	end



end