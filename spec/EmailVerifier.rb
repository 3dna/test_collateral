require 'yaml'
require 'nationbuilder'
require 'pry'
 
describe "Email API integration Tests" do
  
  def extract_value(result, expected_position)
    # binding.pry
    expected_position.each do |x|
      # puts result[x]
      if result[x] != nil
        result = result[x]
      else
        # puts result
      end
    end
    result
  end

  def convert_string_sym(params)
    # i wish we had the function available from Rails
    temp = params.map{|k,v| {k.to_sym => v} }
    if temp.count == 1
      temp.first
    else
      temp[0].merge! temp[1]
    end
  end  

  def api_call(client, endpoint, method, params)
    result = client.call(endpoint.to_sym, method.to_sym, params)
    
    # check the result is not errored
    # puts result
    result
  end

  def create_a_person client
    r = Random.new
    email = "abc#{r.rand(10000)}@gmail.com"
    result = client.call(:people, :create, {person: {first_name: 'test_user', email: email}})
    result['person']['id']
  end

 	it 'API call for email reads' do
		parsed = begin
  		YAML.load(File.open("spec/TestCases_dev.yml"))
			rescue ArgumentError => e
  			puts "Could not parse YAML: #{e.message}"
		end
    
    parsed.each do |k, v|
      if v['read'] == 'true'
  			slug = v['slug']
  			token = v['token']
  			endpoint = v['endpoint']
  			method = v['method']
  			params = v['params']
        expected_position = v['expected_position']
        expected_value = v['expected_value']
        
        # its not a symbol when it comes out of the yml file
        params = params.map{|k,v| {k.to_sym => v} }.first
  			client = NationBuilder::Client.new(slug, token, base_uri: 'http://abeforprez.nbuild.dev')

        result = client.call(endpoint.to_sym, method.to_sym, params)
        actual_value = extract_value result, expected_position
        puts method
        puts actual_value
        puts expected_value
      end
		end 
  end

  it 'Create API' do
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    input = parsed['create']
    params = convert_string_sym(input['params'])
    client = NationBuilder::Client.new(input['slug'], input['token'], 'http://abeforprez.nbuild.dev')
    result = api_call(client, :people, :create, params)
    actual_value = extract_value result, input['expected_position']
    puts actual_value
    puts input['expected_value']
  end

  it 'Update API' do
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    # binding.pry
    input = parsed['update']
    params = convert_string_sym(input['params'])
    client = NationBuilder::Client.new(input['slug'], input['token'], 'http://abeforprez.nbuild.dev')
    id = create_a_person client
    params[:id] = id

    r = Random.new
    params[:person]["email"] = "abc#{r.rand(10000)}@gmail.com"
    result = api_call(client, :people, :update, params)

    actual_value = extract_value result, input['expected_position']
    puts actual_value
    puts params[:person]["email"]
  end

  it 'Delete API' do
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    binding.pry

    input = parsed['destroy']
    client = NationBuilder::Client.new(input['slug'], input['token'], base_url: 'http://abeforprez.nbuild.dev:3000')
    id = create_a_person client
    input["params"][:id] = id
    params = convert_string_sym(input['params'])
    result = api_call(client, :people, :destroy, params)

    puts result
    puts input['expected_value']
  end

  it 'Donation index' do
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    input = parsed['donor_index']
    client = NationBuilder::Client.new(input['slug'], input['token'], base_url: 'http://abeforprez.nbuild.dev')
   
    params = convert_string_sym(input['params'])
    result = api_call(client, :donations, :index, params)
 
    actual_value = extract_value result, input['expected_position']

    if actual_value == nil
      puts "FAILED"
    else
      puts actual_value
      puts "PASSED"
    end
  end

  it 'Donation Create with existing signup' do
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    input = parsed['donor_create_existing']
    client = NationBuilder::Client.new(input['slug'], input['token'], {base_url: 'http://abeforprez.nbuild.dev'})
   
   # binding.pry
    params = convert_string_sym(input['params'])
    result = api_call(client, :donations, :create, params)
    actual_value = extract_value result, input['expected_position']

    puts actual_value
    puts 50000
  end

  it 'Donation Create new signup' do
    skip 'low priority complete later'
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    input = parsed['donor_create_new']
    client = NationBuilder::Client.new(input['slug'], input['token'])
   
   # binding.pry
    params = convert_string_sym(input['params'])
    result = api_call(client, :donations, :create, params)
    actual_value = extract_value result, input['expected_position']

    # read response status
    if result['donation']['succeeded_at'] == nil
      puts "FAILED"
    else
      puts "PASSED"
    end
  end

  it 'Donation Update' do
    skip 'low priority complete later'
    parsed = begin
      YAML.load(File.open("spec/TestCases_dev.yml"))
      rescue ArgumentError => e
        puts "Could not parse YAML: #{e.message}"
    end
    
    input = parsed['donor_update']
    client = NationBuilder::Client.new(input['slug'], input['token'])
   
   # binding.pry
    params = convert_string_sym(input['params'])
    result = api_call(client, :donations, :update, params)
    actual_value = extract_value result, input['expected_position']

    if result['donation']['succeeded_at'] == nil
      puts "FAILED"
    else
      puts "PASSED"
    end
  end

  it 'Donation delete'
end




















