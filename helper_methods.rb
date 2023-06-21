require 'google/apis/civicinfo_v2'

class HelperMethods
  def self.clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
  end

  def self.clean_phone_number(phone_number)
    return nil if phone_number.nil?

    digits = phone_number.gsub(/\D/, '')

    case digits.length
    when 10
      digits
    when 11
      digits[0] == '1' ? digits[1..-1] : nil
    else
      nil
    end
  end

  def self.legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'YOUR_GOOGLE_API_KEY'

    begin
      civic_info.representative_info_by_address(
        address: zip,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
      ).officials
    rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
  end

  def self.save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
      file.puts form_letter
    end
  end
end
