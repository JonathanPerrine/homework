require "csv"
require_relative 'rate_area_book'
require_relative 'plan_book'

class Slcsp

	attr_accessor :rate_area_book, :plan_book

	def initialize rates = nil, plans = nil
		@rate_area_book = rates
		@plan_book = plans
	end


	def find_SLCSP_for_zip_codes zip_code_array
		rate_rows = []
		zip_code_array.each do |zip|
			rate_area = find_areas_by_zip_code zip
			plan_rates = find_plan_rates_by_rate_areas(rate_area)
			slcsp_rate = plan_rates.nil? ? nil : find_second_lowest_cost(plan_rates)
			rate_rows << [zip, slcsp_rate]
		end
		rate_rows
	end

	def find_second_lowest_cost cost_array
		return cost_array.uniq.sort.take(2).slice(-1)
	end

	def find_areas_by_zip_code zip_code
		return nil if rate_area_book.nil?
		rate_area_book.find_areas zip_code
	end

	def find_plan_rates_by_rate_areas rate_area
		return nil if plan_book.nil?

		plan_book.find_plan_rates rate_area
	end

	def build_rate_area_book_from_file filepath
		@rate_area_book = RateAreaBook.new(filepath)
	end

	def build_plan_book_from_file filepath
		@plan_book = PlanBook.new(filepath)
	end

	def gather_zipcodes_from_file filepath
		zip_codes = []
		# Expected Plan Row format is [state, rate_area, rate]
		CSV.foreach(filepath, :headers => true) do |zip_row|
			zip_codes.push zip_row['zipcode']
		end
		zip_codes
	end

	def add_slcsp_rate_to_file filepath, rate_rows
		# Expected Plan Row format is [state, rate_area, rate]
		CSV.open(filepath, 'wb+') do |file|
			file.puts ['zipcode','rate']
			rate_rows.each do |rate_row|
				file.puts rate_row
			end
		end
	end


end
