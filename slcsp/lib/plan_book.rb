class PlanBook

	attr_accessor :plan_rate_rows


	def initialize rate_plan_filename
		plan_rate_rows = []
		# Expected Plan Row format is [state, rate_area, rate]
		CSV.foreach(rate_plan_filename, :headers => true) do |plan_row|
			if plan_row['metal_level'] == 'Silver'
				plan = []
				plan[0] = plan_row['state']
				plan[1] = plan_row['rate_area']
				plan[2] = plan_row['rate']
				plan_rate_rows.push plan
			end
		end
		@plan_rate_rows = plan_rate_rows
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