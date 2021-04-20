require 'date'
require 'csv'

# CLASSES

# Doctor

class Doctor
    attr_reader :rate_multiplier, :grade_hourly_rate, :employer_name
    
    def initialize(attributes = {})
        @id = attributes[:id]
        @grade_title = attributes[:grade_title]
        @grade_hourly_rate = attributes[:grade_hourly_rate]
        @employer_name = attributes[:employer_name]
        @employer_type = attributes[:employer_type]
        @rate_multiplier = attributes[:rate_multiplier]
    end
end

# Department

class Department
    attr_reader :rate_multiplier, :name

    def initialize(attributes = {})
        @id = attributes[:id]
        @name = attributes[:name]
        @rate_multiplier = attributes[:rate_multiplier] || 1
    end
end

# Shift

class Shift
    attr_accessor :id
    attr_reader :start_datetime, :end_datetime, :total_hours, :rate_multiplier, :total_payment, :doctor, :department

    def initialize(attributes = {})
        @id = attributes[:id]
        @start_datetime = attributes[:start_datetime]
        @end_datetime = attributes[:end_datetime]
        
        @department = attributes[:department]
        @doctor = attributes[:doctor]


        @total_hours = set_total_hours
        @rate_multiplier = set_rate_multiplier
        @total_payment = set_total_payment
    end

    private

    def set_total_hours
        ((@end_datetime - @start_datetime) * 24).to_f
    end

    def set_rate_multiplier
        @doctor.rate_multiplier * @department.rate_multiplier
    end

    def set_total_payment
        (@doctor.grade_hourly_rate * @total_hours * @rate_multiplier).round(2)
    end
end

# ShiftRepository

class ShiftRepository
    def initialize
        @shifts = []
        @next_id = 1
    end

    def create(shift)
        shift.id = @next_id
        @shifts << shift
        @next_id += 1
    end

    def export_csv
        CSV.open('shifts.csv', 'wb') do |csv|
            csv << ['shift_id', 'start_date', 'start_time', 'end_date', 'end_time', 'total_hours', 'rate_paid_at', 'total_payment', 'employer_name', 'department_name' ]
            @shifts.each do |shift|
                csv << [shift.id, shift.start_datetime.strftime("%d/%m/%Y"), shift.start_datetime.strftime("%H:%M"), shift.end_datetime.strftime("%d/%m/%Y"), shift.end_datetime.strftime("%H:%M"), shift.total_hours, shift.rate_multiplier.round(2), shift.total_payment, shift.doctor.employer_name, shift.department.name]
            end
        end
    end
end

# - - - - - - - - - - - - - - - - - - - -

# INITIALISATION

# Departments

general_medicine = Department.new({
    id: 1,
    name: 'General Medicine',
    rate_multiplier: 1,
    })

accident_and_emergency = Department.new({
    id: 2,
    name: 'Accident and Emergency',
    rate_multiplier: 1.5,
    })


# Doctors

mwf_hospital_doctor = Doctor.new({
    id: 1,
    grade_title: 'GP',
    grade_hourly_rate: 45,
    employer_name: 'MWF Hospital',
    employer_type: 'hospital',
    rate_multiplier: 1,
    })

mwf_agency_doctor = Doctor.new({
    id: 2,
    grade_title: 'GP',
    grade_hourly_rate: 45,
    employer_name: 'MWF Agency',
    employer_type: 'agency',
    rate_multiplier: 1.8,
    })

tt_agency_doctor = Doctor.new({
    id: 3,
    grade_title: 'Surgeon',
    grade_hourly_rate: 60,
    employer_name: 'TT Agency',
    employer_type: 'agency',
    rate_multiplier: 1.3,
    })

tt_hospital_doctor = Doctor.new({
    id: 4,
    grade_title: 'Surgeon',
    grade_hourly_rate: 60,
    employer_name: 'TT Hospital',
    employer_type: 'hospital',
    rate_multiplier: 1,
    })

# Shifts

mon_1 = Shift.new({
    start_datetime: DateTime.new(2018,10,17,9),
    end_datetime: DateTime.new(2018,10,17,15),
    department: general_medicine,
    doctor: mwf_hospital_doctor,
    })

mon_2 = Shift.new({
    start_datetime: DateTime.new(2018,10,17,20),
    end_datetime: DateTime.new(2018,10,18,8),
    department: accident_and_emergency,
    doctor: mwf_agency_doctor,
    })

tue_1 = Shift.new({
    start_datetime: DateTime.new(2018,10,18,9),
    end_datetime: DateTime.new(2018,10,18,15),
    department: general_medicine,
    doctor: tt_agency_doctor,
    })

tue_2 = Shift.new({
    start_datetime: DateTime.new(2018,10,18,20),
    end_datetime: DateTime.new(2018,10,19,8),
    department: accident_and_emergency,
    doctor: tt_hospital_doctor,
    })

wed_1 = Shift.new({
    start_datetime: DateTime.new(2018,10,19,9),
    end_datetime: DateTime.new(2018,10,19,15),
    department: general_medicine,
    doctor: mwf_hospital_doctor,
    })

wed_2 = Shift.new({
    start_datetime: DateTime.new(2018,10,19,20),
    end_datetime: DateTime.new(2018,10,20,8),
    department: accident_and_emergency,
    doctor: mwf_agency_doctor,
    })

thu_1 = Shift.new({
    start_datetime: DateTime.new(2018,10,20,9),
    end_datetime: DateTime.new(2018,10,20,15),
    department: general_medicine,
    doctor: tt_agency_doctor,
    })

thu_2 = Shift.new({
    start_datetime: DateTime.new(2018,10,20,20),
    end_datetime: DateTime.new(2018,10,21,8),
    department: accident_and_emergency,
    doctor: tt_hospital_doctor,
    })

fri_1 = Shift.new({
    start_datetime: DateTime.new(2018,10,21,9),
    end_datetime: DateTime.new(2018,10,21,15),
    department: general_medicine,
    doctor: mwf_hospital_doctor,
    })

fri_2 = Shift.new({
    start_datetime: DateTime.new(2018,10,21,20),
    end_datetime: DateTime.new(2018,10,22,8),
    department: accident_and_emergency,
    doctor: mwf_agency_doctor,
    })

shifts_array = []
shifts_array << mon_1 << mon_2 << tue_1 << tue_2 << wed_1 << wed_2 << thu_1 << thu_2 << fri_1 << fri_2

# ShiftRepository

shift_repository = ShiftRepository.new

shifts_array.each do |shift|
    shift_repository.create(shift)
end

# Export shifts.csv

shift_repository.export_csv

# - - - - - - - - - - - - - - - - - - - -

# Comments

# Doctor class - Opted for a single Doctor class, rather than separate AgencyDoctor and PermanentDoctor classes inheriting from a Doctor parent class. I understand that you may have liked me to demonstrate inheritance, but I feel this makes more sense in the context of a doctor likely changing between agency and permanent work at various points in their career.

# Initialisation - I probably could have been clever and mapped over the shifts_array to dynamically create the date variables from a starting date, given there were essentially two types of shift. However, that would take a fair amount of time and didn't appear to be the focus of the challenge.