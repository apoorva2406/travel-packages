class Booking < ActiveRecord::Base
	extend FriendlyId
  friendly_id :book_type, use: :slugged
	belongs_to :user
	validates :name, :phone, :book_type, :start_date, :end_date, :user_id, :property_id, :total_amount,:seats, presence: true
	belongs_to :property
	has_many :payments, :foreign_key => "booking_id", :dependent => :destroy
	#after_create :send_mail_to_owner
	
	def send_mail_to_owner
		#self.booking_message
		UserMailer.booking_client_email(self).deliver
		UserMailer.booking_owner_email(self).deliver
	end

	def booking_message
    begin
      @client = Twilio::REST::Client.new ENV['account_sid'], ENV['auth_token']
      property = self.try(:property)
      booking_user_no =  '+918959294300' #self.try(:phone)
      owner_no = '+918959294300' #property.user.try(:mobile_no)

      @client.account.messages.create(
        :body => "You have successfully booked #{property.try(:name)}. Booking start_date #{self.try(:start_date)} to #{self.try(:end_date)}, total amount is #{self.try(:total_amount)}",
        :to => "#{booking_user_no}",    
        :from => "++12173647554"
      ) 

      @client.account.messages.create(
        :body => "Your property #{property.try(:name)} booked by #{self.try(:name)}. Booking start_date #{self.try(:start_date)} to #{self.try(:end_date)}, total amount is #{self.try(:total_amount)}",
        :to => "#{owner_no}",    
        :from => "++12173647554"
      )  

      message = "Otp send successfully"
    rescue Twilio::REST::RequestError => e
      message = "Something is wrong"
    end
  end
 
	def params_list_patym
		amount = self.user.eql?(self.property.user) ? 0 : self.total_amount
		paramList = Hash.new
		paramList["MID"] = ENV['MID']
		paramList["INDUSTRY_TYPE_ID"] = ENV['INDUSTRY_TYPE_ID']
		paramList["CHANNEL_ID"] = ENV['CHANNEL_ID']
		paramList["WEBSITE"] = ENV['WEBSITE']
		paramList["TXN_AMOUNT"] = ENV['website_environment'].eql?("production") ? amount : "2"
		paramList["ORDER_ID"] = SecureRandom.urlsafe_base64(nil, false)
		paramList["CUST_ID"] = SecureRandom.urlsafe_base64(nil, false)  
		paramList
	end

	def params_list_payumoney
		amount = self.user.eql?(self.property.user) ? 0 : self.total_amount
		paramList = Hash.new
		paramList["key"]= ENV['payumoney_key']
		paramList["txnid"] = SecureRandom.urlsafe_base64(nil, false)
		paramList["amount"] = 2.0 #amount
		paramList["productinfo"] = self.try(:property).try(:name)
		paramList["firstname"]= self.try(:name)
		paramList["email"]= self.try(:user).try(:email)

		keys = paramList.keys
		str = nil
    keys.each do |k|
      if str.nil?
        str = paramList[k].to_s
        next
      end
      str = str + '|'  + paramList[k].to_s
    end
    str = str + '|||||||||||' + ENV['payumoney_salt']

    paramList["phone"]= self.try(:phone)
    paramList["service_provider"] = "payu_paisa"
  	paramList["hash"] = Digest::SHA512.hexdigest(str)
  	paramList
	end

	def self.unconfirmed_booking
		@bookings = Booking.where(status: 'not confirm').where("created_at <= ?", Time.now - 24.hours)
		@bookings.delete_all
	end

	def self.import(file,user_id)
		array = []
	  data = open_spreadsheet(file)
	  header = data.row(1)
	  transaction do
		  (2..data.last_row).each do |line|
		    row = Hash[[header, data.row(line)].transpose]
		    blank_key = row.select{|k,v| k if v.blank? && v.nil?}
		    array << {"Row_#{line} have blank columns" => blank_key.keys.join(',')}
		    if blank_key.present?
		    	raise ActiveRecord::Rollback  
			  else

			  	if !(row['Phone'].to_s.size == 10) && Booking.numeric(row['Total Seats']) && 
			  		Booking.numeric(row['Total Amount'])
			  		array << {"Row_#{line} have syntax problems columns" => "Phone, Total Seats , Total amount"}
			  		raise ActiveRecord::Rollback  
			  	else
				  	booking = Booking.new
				    booking.name = row['Name']
				    booking.phone = row['Phone']
				    booking.seats = [row['Total Seats']]
				    booking.start_date = row['Booking Start Date (dd/mm/yyyy)']
				    booking.end_date = row['Booking End Date (dd/mm/yyyy)']
				    booking.status = row['Status']
				    booking.total_amount = row['Total Amount']
				    booking.walk_in = true
				    booking.user_id = user_id
				    booking.save(:validate => false)
				  end  
			  end  
		  end
		end 
		return array.reject{|v| v if v.first[1].blank?} 
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
		  when ".csv" then Roo::CSV.new(file.path)
		  when ".xls" then Roo::Excel.new(file.path)
		  when ".xlsx" then Roo::Excelx.new(file.path)
		  else raise "Unknown file type: #{file.original_filename}"
	  end
	end

	def self.numeric(val)
    return true if val =~ /\A\d+\Z/
    true if Float(val) rescue false
  end
end


