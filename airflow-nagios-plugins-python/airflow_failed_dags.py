import requests, sys, argparse

parser = argparse.ArgumentParser(description="Check Airflow execution time")
parser.add_argument("--host", help="Airflow host name", required=True)
parser.add_argument("--port", help="Airflow host name", required=True)
parser.add_argument("--user", help="Airflow host name", required=True)
parser.add_argument("--password", help="Airflow host name", required=True)
args = parser.parse_args()
url = "http://" + args.host + ":" + args.port + "/api/v1/dags"
response = requests.get(url, auth=(args.user, args.password))
dag_list = response.json()["dags"]
failed_dag_runs = []
for dag in dag_list:
    dag_durations = []
    dag_id = str(dag["dag_id"])
    response = requests.get(
        url + "/" + dag_id + "/dagRuns",
        auth=(args.user, args.password),
        params={"state": "failed", "order_by": "-execution_date"},
    )
    dag_runs = response.json()["dag_runs"]
    for dag_run in dag_runs:
        if dag_run["state"] == "failed":
            failed_dag_runs.append(
                "The DAG " + dag_run["dag_id"] + "is in failed state \n"
            )
if failed_dag_runs:
    sys.stdout.writelines(failed_dag_runs)
    sys.exit(2)  # CRIT
sys.exit(0)  # OK
