require 'active_support/all'

# Please note that you need to be logged into abeforprez on dev machine, and then only token can be generated
class DevNation1
  def nation_name
    'abeforprez'
  end

  def pulse_url
  	'http://abeforprez.nbuild.dev:4000'
  end

  # Access token of the test app 
  def access_tokens
    [ '69b50ddb3508cb96cf630bf66029672e105e6f004e581e0625ec67b1fa05f269', '11737ccc85849c58e8cd7d67beaf366f858626db9187b3ae459a26d7ff85a634', 
    	'09a1c018859c11ae0e31676b373ebc3248179ac3da8560e6af4f036d2b092562', 'e4d554dc9c104acc9dc0fd9f09332af6c2b7488e0a78826a1ccd8c7ace68f87a',
      'dd119152b1b39fa4f5f9bc8606f63338f7944019bbf53c0619ffddb133652dc2', 'ad64b388a6bb5e2eb11f6da4c61ec3838e8f67d8e6a5ba3e76c9730ecabc5932'] 
  end

  # public app 
  # app devteamstat
  # Client id = 10511d3b6d7bfbe88f1b47ab96e38264d9bffdc7bee6e223c6b588dbc991ba32
  # Client secret = 655e7f2bfa0411e717a801c1f73ca2bfdb8e116652c758a334e0ea4eeac34ad5
  # redirect url = https://www.runscope.com/oauth_tool/callback
  def public_app1_tokens
    ['adacf8c89226cece2bc67e90457e48d4b61f5a3db18363eac95be8f2ed4d767f', 'c47a114ef2b50102a7dff85d4e8aaea17645f9de5f985f7bde410d2889c78fc4',
      '19105a3635a80a9780ac43748c615836d2b93ea8354fb08f1802a3928b590662', '3c8b3cd29032d9c01e43e352b06f9f4084929cc24a073c7e0c34fe4ae04338b4',
      '0721c1f5e5a31d2cd091f234174585923c897e7554919e997f34d96baa44295d', 'aa57b6764ef125ac09444f5ab09be2b025334d833273b9e94200f77a76b033f4']
  end
end

class DevNation2
	def nation_name
    '3dna'
  end

  def pulse_url
  	'http://3dna.nbuild.dev:4000'
  end

  # Access token of the test app 
  def access_tokens
    [ '79f8e2bad8e8bbebf9c60e3322dc1e90768a1dff2a2b940e19e61b084158a393', 'e680bc675a27f6066c422a713b6e0312bbe267ef27001696e88f7ab455c10062',
    	'6cd9b4fbe763ca2c7d17266bc526b00de2a6d48333abb998671d07cbfe84edd6', '8a2b35a175f12392870405ae437e44c97aeb0d3fc61c6861373ab1672e5069e6',
    	'f70ea988256e35a4dc1f38684736550b9f881080507bc66e6b0dd0f1a9bc30d4', '0c480b4fbbf1a055c79e095171bd9a94654473847872deaa2c4dd23694fc8c44']
  end

  # abeforprez app installed on 3dna
  def public_app1_tokens
    [ 'ea84bb8e5118533250f0efeffc362ae4a88bd0898aea3b16a0bee442b5a97dee', 'a281640b29172aa79694be38382c74d24bb7f9121f964b08b3600a091db4c864',
      'b2d7baaa29709a882408429360e9014bee8fe9976e5b0c27c4687f5b62c8d05d', 'c53990aba0d584aeeda8a0c2ba764d33572987b2caebe4df6c41d10fd63ca709',
      'b25e28db1b5ebb54dc02dcf2a0edf23c3a92dbebfe2859a7f17f208505e52888', '048b3f0a0233425735614a87da36cd6bd7a838c6999a767f33fd348975ea2639']
  end

end

class DStagingNation1
	def nation_name
    'regress'
  end

  def pulse_url
  	'https://regress.nbstaging.net'
  end

 	#'ea31e2f809e6cfc19889f99e004b1fca804766c315a45c888c8ebe58c72b8aa6'
  def invalid_access_token
  	'a5caa039fe78831d54b5e3fa8cfbaa9ab3495f9840a8bbdd41cc5961be679dce' 
  end

  # Access token of the test app 
  def access_tokens
		[	'cfad561ca9b2c494f7d14226d13fc4c4c5fdc45ce97b9eaa8be58840f2604a34', '48ae78560dc179b3e992d8656ac860bea7f330bf7a5f07945a0fdd41d6ebee3e', 
			'ed1706f55cad6bb1d3ea8c1c12269ee387c728c3a1140237b6272a50ce85db81',
			'a4d142c8568a2d3654da655f355803fc12656941e638079c226c2a4aa399f812', '4e7d70de34a23fb897c8032e33a5d2f30b8dc3df23707b15161f1a4e3cc8712a']
  end

  # abeforprez app installed on 3dna
  def public_app1_tokens
    [ 'db7ae7f333cccfef376b9c6bcca45ec2cdf03b239cfca677fce43fe149fef794', 'd922c63607d5d1e7465a053a346e446890e98bf77652d09f8ca7b3519b5174b0',
      '6ff374c5de093d30a6eaafb1fb10bf4e79ef384afadc272da59dfc891fb10495', '7e072956f82ecc5a89541a25ba4b5b64f3b1623244fd0aa3efcfed722a156448',
      'ab317532fb2563c3cbdcb128f6f23316052d68dfa7b4b747a0141821060c1f3a', '5f523de12e4659a00d11d9e206fabcf706ed8c72795578bed766bd838c69ccb1']
  end
end

class StagingAppToDelete
	def nation_name
    'abeforprez'
  end

  def pulse_url
  	'https://abeforprez.nbstaging.net'
  end

  # Access token of the test app 
  def public_app1_tokens
		[	'8f585d4b68b3fa37324c0fe27145f674e3f1afb455610cebeda7496380f2aa7e', '59489dac7a3168cf422792edfc87e332a09de439d07c5a7091917e08199d424d', 
			'5dff21c372702cd2db275a0e2e9a75ffd19b214e7fb7ec7c787317456ef79428', 'f9208bd7768597634e930b9268964922c2f30ba29b69238400732f4a750f55a2']
  end

  def access_tokens
		[	'71fd2e2f835836c609a2bd039fa3ce51ba82152f34ee00418277c864d63e60a4', 'dc11470872a97430d25248b005ed22861e802efd1f360a47e8219ffc6092bf8a']
  end
end

class StagingNationToDelete
	def nation_name
    'todeletenation'
  end

  def pulse_url
  	'https://todeletenation.nbstaging.net'
  end

  def access_tokens
		[	'dc758dcfb01310ab9964e74dfe4ba538f70eaa3351b693836aac6a7eadb15498', 'f7a660deb4406f7e85199f6154ef5f5eda4d5d2b3f2787a7e8a052c6712c0728']
  end
end

class StagingSharedApp
	# host nation
	def nation_name1
    'abeforprez'
  end

  # shared nation for the app. The app is private. So the policy applied should be private policy.
  def nation_name2
    'regress'
  end

  def pulse_url1
  	'https://abeforprez.nbstaging.net'
  end

	def pulse_url2
  	'https://regress.nbstaging.net'
  end

  def access_tokens1
		[	'71fd2e2f835836c609a2bd039fa3ce51ba82152f34ee00418277c864d63e60a4', 'dc11470872a97430d25248b005ed22861e802efd1f360a47e8219ffc6092bf8a']
  end

  def access_tokens2
		[	'a5caa039fe78831d54b5e3fa8cfbaa9ab3495f9840a8bbdd41cc5961be679dce', 'ed1706f55cad6bb1d3ea8c1c12269ee387c728c3a1140237b6272a50ce85db81']
  end

  def public_nation1_tokens
		[	'8f585d4b68b3fa37324c0fe27145f674e3f1afb455610cebeda7496380f2aa7e', '59489dac7a3168cf422792edfc87e332a09de439d07c5a7091917e08199d424d', 
			'5dff21c372702cd2db275a0e2e9a75ffd19b214e7fb7ec7c787317456ef79428', 'f9208bd7768597634e930b9268964922c2f30ba29b69238400732f4a750f55a2']
  end

  def public_nation2_tokens
		[ 'b6e1a7a56ac1b96f08568c980ab0aa0436b8de0e89b1004540627374c7a9c650', '53ff058b66953848471f815a1ab82a4c5cb52d8c7ca59fdd84ace667daa03dfa']
  end
end



class ProdTokens
	# Not Implemented
end

# # the implicit flow is much better at generating tokens
	def get_access_token
	  parameters = {
        response_type: 'token',
        client_id: 'e83981dab288ebff6828d14e58f8faaf86dbe35b3a8a5d122fc32ddf76befdad',
        client_secret: '3006af1df6b9e664234f47dbef4c697fa72bc7f744bd33ff1f922f617fba13a3',
        redirect_uri: 'https://www.runscope.com/oauth_tool/callback'
     }
    auth_code = "http://regress.nbstaging.net/oauth/authorize?#{parameters.to_query}"
    puts auth_code
	end

#puts get_access_token
