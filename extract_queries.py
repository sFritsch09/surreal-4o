import json
import sys

def extract_assistant_queries(jsonl_input, surql_output):
    with open(jsonl_input, 'r') as infile, open(surql_output, 'w') as outfile:
        query_number = 1
        for line in infile:
            if not line.strip():
                continue  # Skip empty lines
            try:
                entry = json.loads(line)
                messages = entry.get('messages', [])
                for message in messages:
                    if message.get('role') == 'assistant':
                        query = message.get('content', '').strip()
                        if query:
                            outfile.write(f"// Query {query_number}\n{query}\n\n")
                            query_number += 1
            except json.JSONDecodeError:
                print(f"Skipping invalid JSON line: {line}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python extract_queries.py <jsonl_input> [surql_output]")
        sys.exit(1)

    jsonl_input = sys.argv[1]
    surql_output = sys.argv[2] if len(sys.argv) >= 3 else 'assistant_queries.surql'

    extract_assistant_queries(jsonl_input, surql_output)
    print(f"Assistant queries have been saved to {surql_output}")