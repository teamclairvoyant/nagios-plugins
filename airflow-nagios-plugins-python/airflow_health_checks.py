import sys, requests, argparse

parser = argparse.ArgumentParser(description="Check Airflow execution time")
parser.add_argument("--host", type=str, help="Airflow host name", required=True)
parser.add_argument("--port", type=str, help="Airflow host name", required=True)
parser.add_argument("--user", type=str, help="Airflow host name", required=True)
parser.add_argument("--password", type=str, help="Airflow host name", required=True)
args = parser.parse_args()
url = "http://" + args.host + ":" + args.port + "/api/v1/dags"
try:
    response = requests.get(url, auth=(args.user, args.password))
    response.raise_for_status()
except Exception as err:
    sys.stdout.write(str(err))
    sys.exit(2)  # CRIT
if response.status_code != 200:
    sys.stdout.write(response.text)
    sys.exit(2)  # CRIT
sys.stdout.write("Healthy")
sys.exit(0)  # OK
