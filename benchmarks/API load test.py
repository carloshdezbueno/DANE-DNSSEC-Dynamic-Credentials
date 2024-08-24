import os
import requests
import time
import hashlib
import random
import string

def generate_random_string(length=20):
    # Define the characters to choose from: letters and digits
    characters = string.ascii_letters + string.digits
    # Generate a random string using the characters
    random_string = ''.join(random.choice(characters) for _ in range(length))
    return random_string

generated_ids = list()
URL = "http://34.175.46.97:5000"
sha256_checksum = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"

# Set environment variables
IP_ADDRESS = "192.168.0.0"
TLSA_DATA = f"3 1 1 {sha256_checksum}"
DOMAIN = "hogehoge.hoge"

for i in range(0, 10000):
    id = generate_random_string(length=20)
    
    generated_ids.append(id)
    # Set variables
    
    RECORD_NAME = str(id)
    
    # Prepare data payload for POST request
    data_payload = {
        "domain": DOMAIN,
        "record_name": RECORD_NAME,
        "ip_address": IP_ADDRESS,
        "tlsa_data": TLSA_DATA
    }

    # Send POST request
    response = requests.post(f"{URL}/add_record", json=data_payload, headers={"Content-Type": "application/json"})
    print("POST Response ["+ RECORD_NAME +"]:" + response.text)

# Wait for 5 seconds
time.sleep(5)

for id in generated_ids:
    
    # Send DELETE request
    response = requests.delete(f"{URL}/delete_record/{id}")
    print("DELETE Response:", response.text)
