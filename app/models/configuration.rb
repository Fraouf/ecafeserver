require 'singleton'
class Configuration
	include Singleton
	
	attr_reader :locale
	
	def save (params)
		locale = params[:country]
		if (!AVAILABLE_LOCALES.include?(locale))
			return 'invalid_locale'
		end
		@locale = locale
		set
		return true
	end
		
	protected
	def configuration_file
		return "config/configuration"
	end
	
	def get
		f = File.new(configuration_file, "r")
		locale = f.readline.chomp
		f.close
		out = { "locale" => locale }
		return out
	end
	
	def set
		f = File.open(configuration_file, "w")
		f.puts(@locale)
		f.close
	end
	
	def initialize
		out = get
		@locale = out['locale']
	end
end
