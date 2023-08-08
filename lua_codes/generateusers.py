import random
import string
import json
import redis

# Function to generate random name
def generate_name():
    consonants = 'bcdfghjklmnpqrstvwxyz'
    vowels = 'aeiou'
    name_length = random.randint(5, 10)
    name = ''.join(random.choice(consonants) + random.choice(vowels) for _ in range(name_length))
    return name.capitalize()

# Function to generate random roles
def generate_roles():
    roles = ['Admin', 'Moderator', 'User', 'Guest']
    num_roles = random.randint(1, len(roles))
    return random.sample(roles, num_roles)

# Function to generate random email host
def generate_email_host():
    domains = ['example.com', 'testmail.com', 'randommail.org', 'mailservice.net']
    return random.choice(domains)

# Function to generate random email
def generate_email(name):
    domain = generate_email_host()
    rand_str = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))
    return f"{name}.{rand_str}@{domain}"

# Generating random data for 5 users
userdata = []
for _ in range(5):
    name = generate_name()
    email = generate_email(name)
    roles = generate_roles()
    user_info = {'email': email, 'name': name, 'roles': roles}
    userdata.append(user_info)

# Connect to local Redis instance
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

# # Store the user data in Redis under the key "userdata"
# redis_client.set('userdata', json.dumps(userdata))


# Store the user data in Redis
for user in userdata:
    user_key = f"user:{user['email']}"
    user_json = json.dumps({
        'email': user['email'],
        'name': user['name'],
        'roles': user['roles']
    })
    redis_client.set(user_key, user_json)

print("User data stored in local Redis.")



# Write the user data to a local JSON file
with open('userdata.json', 'w') as json_file:
    json.dump(userdata, json_file)

# print("User data stored in pguserdata.json")