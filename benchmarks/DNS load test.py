import subprocess

def run_dns_request():
    # Command to be executed
    command = [
        'dig',
        '+dnssec',
        '@34.175.46.97',
        '-p', '1053',
        'iMuJf6ZBbnRqjrQWd00s.hogehoge.hoge',
        'TLSA'
    ]

    # Execute the command
    result = subprocess.run(command, capture_output=True, text=True)
    
    # Return the output
    return result.stdout

def main():
    for i in range(10000):
        output = run_dns_request()
        print(f"Request {i+1} output:\n{output}")

if __name__ == "__main__":
    main()
