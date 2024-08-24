from flask import Flask, request, jsonify

app = Flask(__name__)

zone_file_path = "/app/coredns-config/hogehoge.hoge.db"

# General functions
def update_serial_number(sum):
    with open(zone_file_path, "r") as file:
        lines = file.readlines()

    with open(zone_file_path, "w") as file:
        for line in lines:
            if line.strip().startswith("@"):
                parts = line.split()

                if sum:
                    parts[6] = str(int(parts[6]) + 1)
                else:
                    parts[6] = str(int(parts[6]) - 1)

                updated_line = "\t".join(parts) + "\n"
                file.write(updated_line)
            else:
                file.write(line)

# Add a record
def insert_block(block):
    with open(zone_file_path, "a") as file:
        file.write(block)

def build_block(domain, record_name, ip_address, tlsa_data, txt_data = None):
    block = f"\n; Start of record {record_name}\n"
    block += f"{record_name}\tIN\t\t\tA\t\t\t{ip_address}\n"
    if txt_data != None:
        block += f"\t\t\tIN\t\t\tTXT\t\t\t\"{txt_data}\"\n"
    block += f"\t\t\tIN\t\t\tTLSA\t\t{tlsa_data}\n"
    block += f"; End of record {record_name}\n"
    return block

@app.route('/add_record', methods=['POST'])
def add_record():
    data = request.get_json()
    domain = data.get('domain')
    record_name = data.get('record_name')
    ip_address = data.get('ip_address')
    # ipv6_address = data.get('ipv6_address')
    txt_data = data.get('txt_data')
    tlsa_data = data.get('tlsa_data')

    if None in [domain, record_name, ip_address, tlsa_data]:
        return jsonify({"message": "Missing data"}), 400

    block = build_block(domain, record_name, ip_address, tlsa_data)
    insert_block(block)
    update_serial_number(True)

    return jsonify({"message": "Record added successfully"}), 201


# Delete a record
def delete_record(record_name):
    with open(zone_file_path, "r") as file:
        lines = file.readlines()

    with open(zone_file_path, "w") as file:
        block_found = False
        skip_next_newline = False
        for line in lines:
            if skip_next_newline:
                skip_next_newline = False
                continue

            if line.strip().startswith(f"; Start of record {record_name}"):
                block_found = True
                skip_next_newline = True
            elif block_found and line.strip().startswith(f"; End of record {record_name}"):
                block_found = False
                skip_next_newline = True
            elif not block_found:
                file.write(line)

    if block_found:
        return False  # Record not found
    else:
        return True   # Record deleted successfully


@app.route('/delete_record/<record_name>', methods=['DELETE'])
def delete_record_endpoint(record_name):
    success = delete_record(record_name)
    if success:
        update_serial_number(False)
        return jsonify({"message": f"Record {record_name} deleted successfully"}), 200
    else:
        return jsonify({"message": f"Record {record_name} not found"}), 404



if __name__ == '__main__':
    app.run(host='0.0.0.0')
