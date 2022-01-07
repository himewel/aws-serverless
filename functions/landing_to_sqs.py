import logging
import sys
from datetime import datetime
from urllib.parse import unquote_plus

import boto3
import csv
import json
from botocore.exceptions import ClientError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def send_messages(queue, messages):
    try:
        entries = [
            {
                "Id": str(ind),
                "MessageBody": msg["body"],
                "MessageAttributes": msg["attributes"],
            }
            for ind, msg in enumerate(messages)
        ]
        response = queue.send_messages(Entries=entries)
        print(response)
    except ClientError as error:
        logger.exception("Send messages failed to queue: %s", queue)
        raise error
    else:
        return response


def pack_message(bucket, msg_path, msg_body, msg_line, header):
    csv_body = list(csv.reader([str(msg_body, "utf-8")]))[0]
    body = dict([(key, value) for key, value in zip(header, csv_body)])

    return {
        "body": json.dumps(body),
        "attributes": {
            "bucket": {"StringValue": bucket, "DataType": "String"},
            "domain": {"StringValue": msg_path.split("/")[0], "DataType": "String"},
            "date": {"StringValue": str(datetime.now()), "DataType": "String"},
            "path": {"StringValue": msg_path, "DataType": "String"},
            "line": {"StringValue": str(msg_line), "DataType": "String"},
        },
    }


def read_file(bucket, filepath):
    s3 = boto3.client("s3")
    data = s3.get_object(Bucket=bucket, Key=filepath)
    contents = data["Body"]
    return contents


def get_queue(name):
    sqs = boto3.resource("sqs")
    try:
        queue = sqs.get_queue_by_name(QueueName=name)
        logger.info(f"Got queue '{name}' with URL={queue.url}")
    except ClientError as error:
        logger.exception(f"Couldn't get queue named {name}.")
        raise error
    else:
        return queue


def pack_file(bucket, filepath, queue_name):
    contents = read_file(bucket, filepath)
    queue = get_queue(queue_name)

    is_header = True
    line_number = 0
    index = 0
    batch_size = 10
    messages = []
    for line in contents.iter_lines():
        if is_header:
            header = list(csv.reader([str(line, "utf-8")]))[0]
            is_header = False
            continue

        index += 1
        line_number += 1
        messages.append(pack_message(bucket, filepath, line, line_number, header))

        if index == batch_size:
            logging.info(f"Sending new batch with {len(messages)} messages")
            send_messages(queue, messages)
            index = 0
            messages = []

    if len(messages) != 0:
        logging.info(f"Sending new batch with {len(messages)} messages")
        send_messages(queue, messages)


def lambda_handler(event, context):
    queue_name = "landing-queue-2152"

    for lambda_event in event["Records"]:
        bucket = lambda_event["s3"]["bucket"]["name"]
        key = unquote_plus(lambda_event["s3"]["object"]["key"], encoding="utf-8")
        pack_file(bucket, key, queue_name)
