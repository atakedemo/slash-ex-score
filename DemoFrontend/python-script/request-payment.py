import requests
import hashlib
  
# api-endpoint
API_ENDPOINT = "https://testnet.slash.fi/api/v1/payment/receive"

# Authentication Token
AUTH_TOKEN = "4c97e77956af1d6e9e5cfea795273709"

# Hash Token
HASH_TOKEN = "Y7fe7232c01e2d2cd3e47564234bde367"
  
# Code set by the merchant to uniquely identify the payment
order_code = "00001"

# Set amount and Generate verify token
amount_to_be_charged = 1 # this number must be Zero or more
raw = '{}::{}::{}'.format(order_code, amount_to_be_charged, HASH_TOKEN)
verify_token = hashlib.sha256(raw).hexdigest()

# data to be sent to api
data = {'identification_token':AUTH_TOKEN,
        'order_code':order_code,
        'verify_token':verify_token,
        'amount':amount_to_be_charged}
  
# sending post request and saving response as response object
r = requests.post(url = API_ENDPOINT, data = data)
  
# extracting response text 
payment_flow_starting_url = r.url
print("The URL is:%s"%payment_flow_starting_url)