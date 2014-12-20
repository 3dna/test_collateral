require 'bundler'
require 'oauth2'
require 'pry'
require 'active_support/all'
Bundler.setup

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class RateLimiting
	attr_accessor :session

	# OAuth redirect url. Basically this can be any url over here. our browser will visit this page if granted auth and 
	# def initialize (nation_name, redirect_url = "#{NBUILD_URL}/oauth/anything")
	def initialize (nation_name)
		@nation_name = nation_name

		# for a public app in abeforprez, soon it will beparameterized
		@client_id = '10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32'
	    @client_secret = '655e7f2bfa0411e717a801c1f73ca2bfdb8e116652c758a334e0ea4eeac34ad5'
	    @redirect_uri = 'http://abeforprez.nationbuilder.com:3000/oauth/service'
		
		@session = Capybara::Session.new(:poltergeist)
		login_as_admin
		puts 'RateLimiting initialized!!'
	end

	def nbuild_port
		3000
	end

	def pulse_port
		4000
	end

	def base_url_nbuild
    	@base_url_nbuild ||= "http://#{@nation_name}.nbuild.dev:#{nbuild_port}"
  	end

  	def base_url_pulse
    	@base_url_pulse ||= "http://#{@nation_name}.nbuild.dev:#{pulse_port}"
  	end

  	# Navigation happens only for web interface that is nbuild
	def goto(uri)
		puts base_url_nbuild
		session.visit "#{base_url_nbuild}#{uri}"
	end

	def login_as_admin
	    goto '/forms/user_sessions/new'
	    session.fill_in 'user_session_email', with: 'help@nationbuilder.com'
	    session.fill_in 'user_session_password', with: 'password'
	    session.click_button 'Sign in with email'

	    #verify that login was successful
	    #expect
	    goto '/admin'
	end

	# can get either type of supported grant_type auth_code or implicit
	# pull out the slug and the API tokens from the YML file
	# over time i will put the code to extract the API token and make it work
	# for now we will return the default from sharksavers everytime
	# this will maintain a pool of ten tokens
	def get_new_token(num_of_tokens)
		expect(num_of_tokens).to be >= 1
		expect(num_of_tokens).to be <= 10

		goto '/admin/oauth/test_tokens'
		
		# @tokens ||= do {
			# session.all('.application')[1].all('td')[1].text
			# session.click_link 'Create token'
			
			# @client ||= NationBuilder::Client.new('sharksavers', 'e3e607abcd34629a24154214f2a7b130a80b55eb3f14d7f1a1933934ad3f002b')
			@client ||= NationBuilder::Client.new(@nation_name, '69b50ddb3508cb96cf630bf66029672e105e6f004e581e0625ec67b1fa05f269', 'http://:nation_name.nbuild.dev:4000')
			puts @client.base_url
			#verify that the call was successfull
		# }
		
		@client
	end

	#app_name for now is DevTeamStat 
	def get_new_private_app_token(app_name)
	 	auth_code = get_authorization_code
	 	puts auth_code
	 	access_token = exchange_for_access_token(grant_type: "authorization_code",
                                         code: auth_code)

	 	puts access_token
	 	NationBuilder::Client.new(@nation_name, access_token)
	 	# 	client.auth_code.authorize_url(:redirect_uri => "#{base_url}/oauth/callback")
		# # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"

		# token = client.auth_code.get_token('authorization_code_value', :redirect_uri => "#{base_url}/oauth/callback", :headers => {'Authorization' => 'Basic some_password'})
		# response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
		# response.class.name
		# # => OAuth2::Response
	end

	def exchange_for_access_token(parameters)
	    all_params = parameters.merge(@client_id, @client_secret, @redirect_url)
	    page.driver.post "/oauth/token", all_params
  	end


	def get_authorization_code
	    puts authorization_url
	    session.visit authorization_url

	    session.save_and_open_page
	    binding.pry

	    session.click_on "Authorize"
	    authorization_code = CGI.parse(current_url.split("?")[1])["code"][0]
	    puts authorization_code
	    authorization_code
	end

	def authorization_url
	    parameters = {
	      response_type: 'token',
	      client_id: '10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32',
	      redirect_uri: 'http://abeforprez.nbuild.dev:3000/oauth/service',
	    }
	    "#{base_url_nbuild}/oauth/authorize?#{parameters.to_query}"
	end

	# def get_new_public_app
	# 	# Not Implemented
	# end
end