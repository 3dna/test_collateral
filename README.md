Test_Collateral
===============

Automated software test and common software libraries.
I have placed random bits of information i found useful in the help.txt file.

API Rating Limiting

1. Response 525 when there are no Keys and nation slug
2. Response becomes 200 when you specify the API Key (= Token) and Nation Slug

Curl Requests to get token
curl --data "grant_type=client_credentials&client_id=749370b02124ab1174c1904e064d5f333c6c6cff8207a3c102e23d94fa4743ff&client_secret=a24064270d9087bb7ff3bacc5230c486926d62f881642aaaceaf23d335403dfe" https://sharksavers.nationbuilder.com/oauth/token

1. If the OAuth server is willing to provide a token, all we need to do is a allow our own tokens to work. I just feel this is the reason our users are doing stuff like picking up access tokens rather than using OAuth API.
2. Write a blog about doing OAuth for API work.

Feedback
{
     1. Struggling to work with OAuth
     2. i don’t know my redirect url
     3. we need to have some sample codes which allow our customers to copy paste the best possible code to allow to connect to our OAuth server. So we can be sure they are safe and we are safe.
     4. url to connect will be https://<nation_slug>.nationbuilder.com/oauth/token
     5. App install process is very confusing, share you app tp your self to install it.
}

--------------------

Commands Process to get the private builds working
{
	nbuild:
     vagrant up and ssh 
     cd /nbuild 
     rails s

    pulse:
     vagrant up and ssh 
     cd ~/src/github.com/3dna/pulse
     make run

     to stop the server, do a Ctril + C to stop rails

     visit: abeforperz.nbuild.dev
     make sure that .pow was installed, it will redirect .nbuild.dev url's to localhost
     please remember that .pow is forwarding your requests to virtual machines fromt he host machines.

     3dna.nbuild.dev:
     tester@nationbuilder.com
     tester
}

Data from nbuild
{
     curl "http://abeforprez.nbuild.dev:4000/api/v1/people?page=1&per_page=10&access_token=69b50ddb3508cb96cf630bf66029672e105e6f004e581e0625ec67b1fa05f269" -v
     kronk -c10 -n110 -H"Content-Type: application/json" "https://regress.nbstaging.net/api/v1/people?page=1&per_page=10&access_token=db7ae7f333cccfef376b9c6bcca45ec2cdf03b239cfca677fce43fe149fef794"
}

Editing Rate Limiting Policy
{
     To find out the current rate policy for a nation
     — http://192.168.52.10:4001/v1/private_policy/3dna
     — http://192.168.52.10:4001/v1/private_policy/<nation>
  
     Curl rate limiter Pulse
     curl "http://abeforprez.nbuild.dev:4000/api/v1/people?page=1&per_page=10&access_token=69b50ddb3508cb96cf630bf66029672e105e6f004e581e0625ec67b1fa05f269"
     — Note no https
     — need to use port 4000 since there is where it is revealed from the VM into the host machine
     — Also .pow is not working in this space, so we need to use the right ports

     To Change the Rate Limit
     curl -XPUT -d'{"Interval":10000000000, "Requests":10}' "http://192.168.52.10:4001/v1/private_policy/abeforprez"
     using apache bench is also possible to hit the server multiple times
     ab -c 15 -n 500 "http://abeforprez.nbuild.dev:4000/api/v1/people?page=1&per_page=10&access_token=69b50ddb3508cb96cf630bf66029672e105e6f004e581e0625ec67b1fa05f269"
}
