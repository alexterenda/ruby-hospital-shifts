require "app"

describe Shift do
    let(:department) { Department.new({
    id: 1,
    name: 'General Medicine',
    rate_multiplier: 1,
    }) }

    let(:doctor) { Doctor.new({
    id: 1,
    grade_title: 'GP',
    grade_hourly_rate: 45,
    employer_name: 'MWF Hospital',
    employer_type: 'hospital',
    rate_multiplier: 1,
    }) }

    let(:shift) { mon_1 = Shift.new({
    start_datetime: DateTime.new(2018,10,17,9),
    end_datetime: DateTime.new(2018,10,17,15),
    department: department,
    doctor: doctor,
    }) }
 
    it "correctly sets total_hours" do  
        expect(shift.total_hours).to eq(6.0)
    end

    it "correctly sets rate_multiplier" do  
        expect(shift.rate_multiplier).to eq(1)
    end

    it "correctly sets total_payment" do  
        expect(shift.total_payment).to eq(270.0)
    end
end