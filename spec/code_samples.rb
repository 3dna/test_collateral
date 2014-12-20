require 'spec_helper'

# # This API call can be loading on the servers Be careful not to go too far.
# describe "API Rating Limiting Tests" do
#   it "is API up and running" do
#     abeforprez = RateLimiting.new('abeforprez')

#     # getting first token to check API
#     private_token = abeforprez.get_new_token(10)

#  		1.times do
#  			body  = private_token.call(:people, :me)
#       response = private_token.response

#       puts response.body
#       puts 'X-Ratelimit-Remaining'
#  		  puts response.header["X-Ratelimit-Remaining"]
#       puts body["person"]["email"]
#     	#expect(body["person"]["first_name"]).to eq("Digvijay")
#  			expect(response.header["X-Ratelimit-Remaining"].first.to_i).to be >= 0
#  		end

#  #  it "Public API up and running" do
#  #    abeforprez = RateLimiting.new('abeforprez')

#  #    # getting first token to check API
#  #    private_client = abeforprez.get_new_private_app_token('abeforprez')

#  #    1.times do
#  #        body  = private_client.call(:people, :me)
#  #        response = private_client.response

#  #        puts response.body
#  #        puts 'X-Ratelimit-Remaining'
#  #        puts response.header["X-Ratelimit-Remaining"]
#  #        puts body["person"]["email"]
#  #        #expect(body["person"]["first_name"]).to eq("Digvijay")
#  #        expect(response.header["X-Ratelimit-Remaining"].first.to_i).to be >= 0
#  #    end
# 	end
# end

describe "RateLimitingTests" do
  def nation_name
    'abeforprez'
  end

  # Access token of the test app 
  def abeforprez_nbuild_tokens
    ['69b50ddb3508cb96cf630bf66029672e105e6f004e581e0625ec67b1fa05f269', '11737ccc85849c58e8cd7d67beaf366f858626db9187b3ae459a26d7ff85a634', '09a1c018859c11ae0e31676b373ebc3248179ac3da8560e6af4f036d2b092562', 
      'dd119152b1b39fa4f5f9bc8606f63338f7944019bbf53c0619ffddb133652dc2', 'ad64b388a6bb5e2eb11f6da4c61ec3838e8f67d8e6a5ba3e76c9730ecabc5932', 'e4d554dc9c104acc9dc0fd9f09332af6c2b7488e0a78826a1ccd8c7ace68f87a']
  end

  # public app 
  # Client id = 10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32
  # Client secret = 655e7f2bfa0411e717a801c1f73ca2bfdb8e116652c758a334e0ea4eeac34ad5
  # redirect url = https://www.runscope.com/oauth_tool/callback
  def abeforprez_devteamstat_app
    ['adacf8c89226cece2bc67e90457e48d4b61f5a3db18363eac95be8f2ed4d767f', 'c47a114ef2b50102a7dff85d4e8aaea17645f9de5f985f7bde410d2889c78fc4',
      '19105a3635a80a9780ac43748c615836d2b93ea8354fb08f1802a3928b590662', '3c8b3cd29032d9c01e43e352b06f9f4084929cc24a073c7e0c34fe4ae04338b4',
      '0721c1f5e5a31d2cd091f234174585923c897e7554919e997f34d96baa44295d', 'aa57b6764ef125ac09444f5ab09be2b025334d833273b9e94200f77a76b033f4']
  end

  # the rate limit is defined as rate limit per 10seconds
  # you can query it as http://192.168.52.10:4001/v1/private_policy/<nation>
  # And you can change it using curl -XPUT -d'{"Interval":10000000000, "Requests":10}' "http://192.168.52.10:4001/v1/private_policy/abeforprez"
  def current_rate
      10
  end

  it "Generate URL for access token - Auth Code flow" do
    parameters = {
        response_type: 'code',
        client_id: '10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32',
        redirect_uri: 'https://www.runscope.com/oauth_tool/callback',
      }
    auth_code = "http://abeforprez.nbuild.dev/oauth/authorize?#{parameters.to_query}"
    puts auth_code
    parameters = {
        client_id: '10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32',
        client_secret: '655e7f2bfa0411e717a801c1f73ca2bfdb8e116652c758a334e0ea4eeac34ad5',
        grant_type: 'authorization_code',
        code: 'de79a2a1bb29717400746c9ef6d24899424b93bb4f31ad1b0ee24c6217917f90',
        redirect_uri: 'https://www.runscope.com/oauth_tool/callback'
      }
    
    access_token = "http://abeforprez.nbuild.dev/oauth/token" #{parameters.to_query}"
  end

  it "Generate URL for access token - Implicit flow" do
    parameters =           response_type: 'token',
        client_id: '10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32',
        client_secret: '655e7f2bfa0411e717a801c1f73ca2bfdb8e116652c758a334e0ea4eeac34ad5',
        redirect_uri: 'https://www.runscope.com/oauth_tool/callback'
     }
    auth_code = "http://abeforprez.nbuild.dev/oauth/authorize?#{parameters.to_query}"
    puts auth_code
  end


  it "can rate limit with private tokens for same nation" do
    responses = Queue.new
    starting_time = Time.now
    thread_pool = []
    pass_counter = 0
    fail_counter = 0

    110.times do |i|
      thread_pool[i] = Thread.new do
        client = NationBuilder::Client.new(nation_name, abeforprez_nbuild_tokens[i % 6], 'http://abeforprez.nbuild.dev:4000')
        begin
          body = client.call(:people, :me)
          response = client.response
          pass_counter += 1
          puts response.header["X-Ratelimit-Remaining"]
        rescue
          # client.call function fails to parse the body when you rate limited
          fail_counter += 1
          puts "the thread failed is #{i}"
        end
      end
    end

    thread_pool.each{ |th|
      th.join;
    }
  
    ending_time = Time.now
    time = ending_time - starting_time
    puts time
    expect(pass_counter).to be 100
    expect(fail_counter).to be 10
  end

  # Call to get access tokens
  # https://sharksavers.nationbuilder.com/oauth/authorize?client_id=dc5e4fb17c58558dc3cec17ff803f74f1745335c6ca02065ca0cadee5b860879
  # &redirect_uri=https%3A%2F%2Fwww.runscope.com%2Foauth_tool%2Fcallback&response_type=code
  it "can rate limit with public tokens separately" do
    responses = Queue.new
    starting_time = Time.now
    thread_pool = []
    pass_counter = 0
    fail_counter = 0

    110.times do |i|
      thread_pool[i] = Thread.new do
        client = NationBuilder::Client.new(nation_name, abeforprez_devteamstat_app[i % 6], 'http://abeforprez.nbuild.dev:4000')
        begin
          body = client.call(:people, :me)
          response = client.response
          pass_counter += 1
          puts response.header["X-Ratelimit-Remaining"]
        rescue
          # client.call function fails to parse the body when you rate limited
          fail_counter += 1
          puts "the thread failed is #{i}"
        end
      end
    end

    thread_pool.each{ |th|
      th.join;
    }
  
    ending_time = Time.now
    time = ending_time - starting_time
    puts time
    expect(pass_counter).to be 100
    expect(fail_counter).to be 10
  end

  it "Rate limit for public & private tokens is separate" do
    responses = Queue.new
    starting_time = Time.now
    thread_pool = []
    public_pass_counter = 0
    public_fail_counter = 0
    private_pass_counter = 0
    private_fail_counter = 0

    220.times do |i|
      thread_pool[i] = Thread.new do
        if (i % 2) == 0
            client = NationBuilder::Client.new(nation_name, abeforprez_devteamstat_app[i % 6], 'http://abeforprez.nbuild.dev:4000')
            begin
              body = client.call(:people, :me)
              response = client.response
              public_pass_counter += 1
              puts response.header["X-Ratelimit-Remaining"]
            rescue
              # client.call function fails to parse the body when you rate limited
              public_fail_counter += 1
              puts "the public thread failed is #{i}"
            end
        else
            client = NationBuilder::Client.new(nation_name, abeforprez_nbuild_tokens[i % 6], 'http://abeforprez.nbuild.dev:4000')
            begin
              body = client.call(:people, :me)
              response = client.response
              private_pass_counter += 1
              puts response.header["X-Ratelimit-Remaining"]
            rescue
              # client.call function fails to parse the body when you rate limited
              private_fail_counter += 1
              puts "the private thread failed is #{i}"
            end
        end
      end
    end

    thread_pool.each{ |th|
      th.join;
    }
  
    ending_time = Time.now
    time = ending_time - starting_time
    puts time
    expect(public_pass_counter).to be 100
    expect(public_fail_counter).to be 10
    expect(private_pass_counter).to be 100
    expect(private_fail_counter).to be 10
  end

end