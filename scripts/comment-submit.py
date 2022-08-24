import requests, os, json
import logging
logging.basicConfig(level=logging.DEBUG)

comments_url = json.load(open(os.environ['GITHUB_EVENT_PATH'], 'r'))['pull_request']['comments_url']
response = requests.post(comments_url, auth=(os.environ['_user'], os.environ['_token']), json={'body':os.environ['_body']}, headers={'user-agent': 'octodns-sync'})
response.raise_for_status()
print(response)