require 'erb'
require_relative 'event_data'
require_relative 'helper_methods'

class EventManager
  def initialize
    @data = EventData.new
    @template_letter = File.read('lib/form_letter.erb')
    @erb_template = ERB.new(@template_letter)
    @registration_hours = Hash.new(0)
    @registration_days = Hash.new(0)
  end

  def run
    puts "Event Manager Initialized"
    process_attendees
    print_peak_hours
    print_peak_days
  end

  private

  def process_attendees
    @data.contents.each do |row|
      id = row[0]
      name = row[:first_name]
      zipcode = HelperMethods.clean_zipcode(row[:zipcode])
      legislators = HelperMethods.legislators_by_zipcode(zipcode)
      registration_timestamp = DateTime.strptime(row[:regdate], '%m/%d/%y %H:%M')
      registration_hour = registration_timestamp.hour
      @registration_hours[registration_hour] += 1
      registration_day = registration_timestamp.wday
      @registration_days[registration_day] += 1

      form_letter = @erb_template.result(binding)
      HelperMethods.save_thank_you_letter(id, form_letter)
    end
  end

  def print_peak_hours
    peak_hours = @registration_hours.select { |_hour, count| count == @registration_hours.values.max }
    peak_hours = peak_hours.keys.sort.join(', ')

    puts "Peak registration hour(s): #{peak_hours}"
  end

  def print_peak_days
    peak_days = @registration_days.select { |_day, count| count == @registration_days.values.max }
    peak_days = peak_days.keys.sort.map { |day| Date::DAYNAMES[day] }.join(', ')

    puts "Peak registration day(s): #{peak_days}"
  end
end

event_manager = EventManager.new
event_manager.run
