import requests
from datetime import timezone, datetime
import sys
import logging
import argparse


def check_airflow_execution_time(url, warn_threshold, crit_threshold):
    alert = 0
    response = requests.get(url, auth=(args.user, args.password))
    dag_list = response.json()["dags"]
    active_dags = [dag for dag in dag_list if dag["is_paused"] not in [True]]
    for dag in active_dags:
        dag_id = str(dag["dag_id"])
        response = requests.get(
            url + "/" + dag_id + "/dagRuns", auth=(args.user, args.password)
        )
        dag_runs = response.json()["dag_runs"]
        for dag_run in dag_runs:
            response = requests.get(
                url
                + "/"
                + dag_id
                + "/dagRuns/"
                + dag_run["dag_run_id"]
                + "/taskInstances",
                auth=(args.user, args.password),
                params={"state": "queued"},
            )
            response = response.json()["task_instances"]
            for task_instance in response:
                if task_instance["start_date"] == None:
                    duration = (
                        datetime.now(timezone.utc)
                        - datetime.fromisoformat(dag_run["start_date"])
                    ).total_seconds() / 60
                else:
                    duration = (
                        datetime.now(timezone.utc)
                        - datetime.fromisoformat(task_instance["start_date"])
                    ).total_seconds() / 60
                if duration > crit_threshold:
                    logging.critical(
                        "Task %s in DAG %s took longer than expected to execute on %s. Execution time: %d minutes",
                        task_instance["task_id"],
                        task_instance["dag_id"],
                        task_instance["execution_date"],
                        duration,
                    )
                    alert = 1

                if duration > warn_threshold and duration < crit_threshold:
                    logging.warning(
                        "Task %s in DAG %s took longer than expected to execute on %s. Execution time: %d minutes",
                        task_instance["task_id"],
                        task_instance["dag_id"],
                        task_instance["execution_date"],
                        duration,
                    )
                    alert += 1
    return alert


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Check Airflow execution time")
    parser.add_argument("--host", help="Airflow host name", required=True)
    parser.add_argument("--port", help="Airflow host name", required=True)
    parser.add_argument("--user", help="Airflow host name", required=True)
    parser.add_argument("--password", help="Airflow host name", required=True)
    parser.add_argument(
        "--warning_threshold",
        type=int,
        help="Warning threshold for execution time in seconds",
        required=True,
    )
    parser.add_argument(
        "--critical_threshold",
        type=int,
        help="Critical threshold for execution time in seconds",
        required=True,
    )
    args = parser.parse_args()

    url = "http://" + args.host + ":" + args.port + "/api/v1/dags"
    alert = check_airflow_execution_time(
        url, args.warning_threshold, args.critical_threshold
    )

    if alert == 1:
        sys.stdout()
        sys.exit(2)  # CRIT
    elif alert:
        sys.stdout()
        sys.exit(1)  # WARN
    else:
        sys.stdout.write("Everything OK!")
        sys.exit(0)  # OK
