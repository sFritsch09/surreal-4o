import json
import sys

# Check if the correct number of arguments are provided
if len(sys.argv) != 3:
    print("Usage: python inject_schema.py <schema_file_path> <jsonl_file_path>")
    sys.exit(1)

schema_file_path = sys.argv[1]
jsonl_file_path = sys.argv[2]

# Read the schema file
with open(schema_file_path, 'r') as schema_file:
    schema = schema_file.read()

# Prepare the system message with the schema
system_message = f"You are a helpful AI assistant that generates SurrealQL queries based on the following schema:\n\n{schema}"

# Read the JSONL file and inject the system message
with open(jsonl_file_path, 'r') as jsonl_file:
    jsonl_entries = [json.loads(line) for line in jsonl_file]

for entry in jsonl_entries:
    for message in entry['messages']:
        if message['role'] == 'system':  # Assuming the placeholder has a 'role' of 'system'
            message['content'] = system_message

# Write the updated JSONL entries to a new file
output_file_path = '00-patch.jsonl'
with open(output_file_path, 'w') as output_file:
    for entry in jsonl_entries:
        json.dump(entry, output_file)
        output_file.write('\n')

print(f"Updated JSONL entries written to {output_file_path}")