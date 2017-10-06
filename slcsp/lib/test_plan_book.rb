class TestPlanBook

	attr_accessor :plan_rate_rows


	def initialize array_of_plan_rate_rows
		@plan_rate_rows = array_of_plan_rate_rows
	end

	# Expected Plan Row format is [state, rate_area, rate]
	def find_plan_rates area_tuple

		rates =[]
		@plan_rate_rows.each do |row|
			rates.push row[2] if row.take(2) == area_tuple

		end
		rates.size > 0 ? rates : nil

	end



end