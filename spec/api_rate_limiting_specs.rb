require 'spec_helper'
require 'tokens'

describe "ManualRateLimitingTests" do
  let(:environment) do
    'dev'
  end

  let(:nation_1) do
    if :environment == 'dev' do
      return DevNation1 
    elseif :environment == 'staging' do
      return StagingNation1
    end
  end

  let(:nation_2) do

  end

  # There are many types of failures and we need to refine our rescue, to only filter actual rejects 
  def execute_api_call(nation_name, token_pool, pulse_url, num_of_calls, num_of_passes, num_of_failures)
    pass_counter = 0
    fail_counter = 0
    thread_pool = []
    pass_list = []
    fail_list =[]
    num_of_calls.times do |i|
      thread_pool[i] = Thread.new {
        begin
          client = NationBuilder::Client.new(nation_name, token_pool[i % token_pool.count], pulse_url)
          body = client.call(:people, :me)

          case client.response.header.status_code
          when 200 
            response = client.response
            pass_counter += 1
            pass_list.push(i)
            puts "Pass #{i} with status_code #{client.response.header.status_code}"
          when 401
            fail_counter += 1
            fail_list.push(i)
            puts "Failed #{i} with status_code #{client.response.header.status_code}"  
          when 429
            fail_counter += 1
            fail_list.push(i)
            puts "Failed #{i} with status_code #{client.response.header.status_code}"  
          else
            p client.response
            fail_counter += 1
            fail_list.push(i)
            puts "Failed #{i} with status_code #{client.response.header.status_code}"  
          end
          
        rescue
          # client.call function fails to parse the body when you rate limited
          case client.response.header.status_code
          when 429 
            fail_counter += 1
            fail_list.push(i)
            puts "Failed #{i} with status_code #{client.response.header.status_code}"
          else
            fail_counter += 1
            fail_list.push(i)
            puts "Failed with status_code #{client.response.header.status_code} !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            p client.response
          end

        end
      }
    end

    thread_pool.each{ |th|
      th.join
    }

    puts "Passing #{pass_list}"
    puts "failing #{fail_list}"
    expect(pass_counter).to be num_of_passes
    puts "#{pass_counter} & #{num_of_passes} & #{pass_counter==num_of_passes}"
    puts token_pool
    puts "#{fail_counter} & #{num_of_failures} & #{fail_counter==num_of_failures}"
    expect(fail_counter).to be num_of_failures
  end

  # private + private tokens
  it "can rate limit with private tokens for same nation, Dev environment" do
    nation1 = DevNation1.new
    execute_api_call nation1.nation_name, nation1.access_tokens, nation1.pulse_url, 110, 100, 10
  end

  it "delete a nation" do
    nation = StagingNationToDelete.new
    execute_api_call nation.nation_name, nation.access_tokens, nation.pulse_url, 110, 100, 10
  end

  # private + private + different nation
  it "can rate limit with private tokens for different nations, Dev environment" do
    t1 = Thread.new {
        nation1 = DevNation1.new
        execute_api_call nation1.nation_name, nation1.access_tokens, nation1.pulse_url, 110, 100, 10
      } 
    t2 = Thread.new {
        nation2 = DevNation2.new
        execute_api_call nation2.nation_name, nation2.access_tokens, nation2.pulse_url, 110, 100, 10  
    }
    t1.join
    t2.join
  end
 
  # public + public for two different Apps 
  it "can rate limit with public tokens separately" do
    nation1 = DevNation1.new
    execute_api_call nation1.nation_name, nation1.public_app1_tokens, nation1.pulse_url, 110, 100, 10
  end

  # Private + public + same nation
  it "Rate limit for public & private tokens is separate" do
    t1 = Thread.new {
        nation1 = DevNation1.new
        execute_api_call nation1.nation_name, nation1.access_tokens, nation1.pulse_url, 110, 100, 10
      } 
    t2 = Thread.new {
        nation1 = DevNation1.new
        execute_api_call nation1.nation_name, nation1.public_app1_tokens, nation1.pulse_url, 110, 100, 10
    }
    t1.join
    t2.join
  end

  it "when an App is shared with another nation both instances have seperate limits" do
      # Not implemented
  end

  # One way is to change the rate limit using curl -XPUT -d'{"Interval":10000000000, "Requests":10}' "http://192.168.52.10:4001/v1/private_policy/abeforprez"
  # during the execution of the test
  it "rating limit changing" do
    nation1 = DevNation1.new
    execute_api_call nation1.nation_name, nation1.access_tokens, nation1.pulse_url, 110, 100, 10
    execute_api_call nation1.nation_name, nation1.access_tokens, nation1.pulse_url, 110, 100, 10
  end

  it 'individual nations can have a private pulse policy as well' do

  end

  it 'revoked tokens should not be allowed' do
    nation1 = DevNation1.new
    token_pool = nation1.access_tokens.push(nation1.invalid_access_token)
    #token_pool = ['a5caa039fe78831d54b5e3fa8cfbaa9ab3495f9840a8bbdd41cc5961be679dce']
    execute_api_call nation1.nation_name, token_pool, nation1.pulse_url, 110, 100, 10
  end

  # update to public app from private
  # delete a public app 
  # delete a private app
  it 'deleted app tokens should be revoked' do
    nation1 = StagingAppToDelete.new
   
    # Nation is working
    # execute_api_call nation1.nation_name, nation1.private_app1_tokens, nation1.pulse_url, 110, 100, 10

    # Upgarde the app
    # execute_api_call nation1.nation_name, nation1.private_app1_tokens, nation1.pulse_url, 110, 100, 10

    # Check if private and public work
    t1 = Thread.new {
        execute_api_call nation1.nation_name, nation1.access_tokens, nation1.pulse_url, 110, 100, 10
      } 
    t2 = Thread.new {
        execute_api_call nation1.nation_name, nation1.public_app1_tokens, nation1.pulse_url, 110, 100, 10
    }
    t1.join
    t2.join

    # delete the app


  end

  # update to public app from private
  # delete a public app 
  # delete a private app
  it 'shared app must have its own limit' do
    nation = StagingSharedApp.new
   
    # Public and private apps hitting
    # t1 = Thread.new {
    #     execute_api_call nation.nation_name1, nation.access_tokens1, nation.pulse_url1, 110, 100, 10
    # }

    # t2 = Thread.new {
    #     execute_api_call nation.nation_name1, nation.public_nation1_tokens, nation.pulse_url1, 110, 100, 10
    # } 

    # public and private apps for the shared nation
    t3 = Thread.new {
        execute_api_call nation.nation_name2, nation.access_tokens2, nation.pulse_url2, 110, 100, 10
    }

    t4 = Thread.new {
        execute_api_call nation.nation_name2, nation.public_nation2_tokens, nation.pulse_url2, 110, 100, 10
    }
    
    t3.join
    t4.join

    # delete the app
    

  end

end  