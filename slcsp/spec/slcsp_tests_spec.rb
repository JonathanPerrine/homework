require 'spec_helper'
require 'slcsp'
require 'test_rate_area_book'
require 'test_plan_book'

describe Slcsp do
	before :all do
		@slcsp = Slcsp.new()
	end

	describe "#find_second_lowest_cost" do

		it "Should give give the only value in an array of only non-unique costs" do
			expect(@slcsp.find_second_lowest_cost [1.0, 1.0, 1.0]).to eq 1.0
		end
		it "Should not return the lowest value is there are multiple non-unique lowest values" do
			expect(@slcsp.find_second_lowest_cost [1.0, 1.0, 1.0, 4.0]).to eq 4.0
		end
		it "Should give give the largest of two items in an array" do
			expect(@slcsp.find_second_lowest_cost [1.0, 10.0]).to eq 10.0
		end
		it "Should give give the middle of three items in an array" do
			expect(@slcsp.find_second_lowest_cost [1.0, 5.0, 10.0]).to eq 5.0
		end

		it "Should give a nil response to an empty array" do
			expect(@slcsp.find_second_lowest_cost []).to eq nil
		end

		it "Should give a nil response to an empty array" do
			expect(@slcsp.find_second_lowest_cost []).to eq nil
		end

	end

	describe "#find_areas_by_zip_code" do
		before :all do
			@common_zip_codes = ['00001', '00022', '00333', '04444', '55555']
			@absent_zip_code = '000000'
			@double_area_zip_code = '66666'

			@slcsp.rate_area_book = TestRateAreaBook.new([['00001', 'CA', 1], ['00022', 'CA', 2], ['00333', 'CA', 3], ['04444', 'OH', 5], ['55555', 'OH', 9],
				[@double_area_zip_code, 'CA', 6], [@double_area_zip_code, 'OH', 6]])
		end

		it "Should locate one-to-one zip codes" do
			expect(@slcsp.find_areas_by_zip_code(@common_zip_codes[0])).to eq ['CA', 1]
			expect(@slcsp.find_areas_by_zip_code(@common_zip_codes[1])).to eq ['CA', 2]
			expect(@slcsp.find_areas_by_zip_code(@common_zip_codes[2])).to eq ['CA', 3]
			expect(@slcsp.find_areas_by_zip_code(@common_zip_codes[3])).to eq ['OH', 5]
			expect(@slcsp.find_areas_by_zip_code(@common_zip_codes[4])).to eq ['OH', 9]
		end

		it "Should return nil for any absent zip codes" do
			expect(@slcsp.find_areas_by_zip_code('00000')).to eq nil
		end
		it "Should return nil for a zip code in multiple rate areas" do
			expect(@slcsp.find_areas_by_zip_code(@double_area_zip_code)).to eq nil
		end

		it "Should return nil if there's no rate book set" do
			@slcsp.rate_area_book = nil
			expect(@slcsp.find_areas_by_zip_code(['00001'])).to eq nil
		end

	end

	describe "#find_plan_rates_by_rate_areas" do
		before :all do
			@slcsp.plan_book = TestPlanBook.new([
				['CA', 1, 284.75],['CA', 1, 296.60],
				['CA', 2, 87.52],['CA', 2, 87.52], ['CA', 2, 87.52],
				['CA', 3, 330.33],
				['OH', 5, 163.10],
				['OH', 9, 219.46],
				['CA', 6, 413.04],['CA', 6, 393.29],['CA', 6, 393.29],['CA', 6, 528.02],
				['OH', 6, 0]
				])
		end
		it "should return nil if no rate exists for state, rate area" do
			expect(@slcsp.find_plan_rates_by_rate_areas(['AL', 10])).to eq nil
		end
		it "should return nil if no rate exists for state" do
			expect(@slcsp.find_plan_rates_by_rate_areas(['NM', 9])).to eq nil
		end
		it "should return nil if no rate exists for rate_area" do
			expect(@slcsp.find_plan_rates_by_rate_areas(['CA', 99])).to eq nil
		end
		it "should return a single existing rates" do
			expect(@slcsp.find_plan_rates_by_rate_areas(['CA', 3])).to eq [ 330.33 ]
		end
		it "should return two different existing rates" do
			expect(@slcsp.find_plan_rates_by_rate_areas(['CA', 1])).to eq [ 284.75, 296.60 ]
		end
		it "should return multiple instances of identical rates" do
			expect(@slcsp.find_plan_rates_by_rate_areas(['CA', 2])).to eq [ 87.52, 87.52, 87.52 ]
		end

	end

	describe "#find_SLCSP_for_zip_codes" do

		it "should locate the correct rates for multiple zip codes" do
			@common_zip_codes = ['00001', '00022', '00333', '04444', '55555']
			@absent_zip_code = '000000'
			@double_area_zip_code = '66666'

			@slcsp.rate_area_book = TestRateAreaBook.new([['00001', 'CA', 1], ['00022', 'CA', 2], ['00333', 'CA', 3], ['04444', 'OH', 5], ['55555', 'OH', 9],
					[@double_area_zip_code, 'CA', 6], [@double_area_zip_code, 'OH', 6]])
			@slcsp.plan_book = TestPlanBook.new([
				['CA', 1, 284.75],['CA', 1, 296.60],
				['CA', 2, 87.52],['CA', 2, 87.52], ['CA', 2, 87.52],
				['CA', 3, 330.33],
				['OH', 5, 163.10],
				['OH', 9, 219.46],
				['CA', 6, 413.04],['CA', 6, 393.29],['CA', 6, 393.29],['CA', 6, 528.02],
				['OH', 6, 0]
				])

			slcsp_results = @slcsp.find_SLCSP_for_zip_codes(['00001', '00022', '00333', '04444', '55555','000000','66666'])
			expect(slcsp_results).to eq [["00001", 296.6], ["00022", 87.52], ["00333", 330.33], ["04444", 163.1], ["55555", 219.46], ["000000", nil], ["66666", nil]]
		end
	end
end