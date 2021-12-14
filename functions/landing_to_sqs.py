import logging
import sys
from urllib.parse import unquote_plus

import boto3
from botocore.exceptions import ClientError

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
        if "Successful" in response:
            for msg_meta in response["Successful"]:
                logger.info(
                    "Message sent: %s: %s",
                    msg_meta["MessageId"],
                    messages[int(msg_meta["Id"])]["body"],
                )
        if "Failed" in response:
            for msg_meta in response["Failed"]:
                logger.warning(
                    "Failed to send: %s: %s",
                    msg_meta["MessageId"],
                    messages[int(msg_meta["Id"])]["body"],
                )
    except ClientError as error:
        logger.exception("Send messages failed to queue: %s", queue)
        raise error
    else:
        return response


def pack_message(msg_path, msg_body, msg_line):
    return {
        "body": msg_body,
        "attributes": {
            "path": {"StringValue": msg_path, "DataType": "String"},
            "line": {"StringValue": str(msg_line), "DataType": "String"},
        },
    }


def read_file(bucket, filepath):
    s3 = boto3.client("s3")
    data = s3.get_object(Bucket=bucket, Key=filepath)
    contents = data['Body']
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

    index = 0
    batch_size = 10
    messages = []
    for line in contents.iter_lines():
        messages.append(pack_message(__file__, line, index))
        index += 1

        if index == batch_size:
            send_messages(queue, messages)
            index = 0
            messages = []
            print(".", end="")
            sys.stdout.flush()

    if len(messages) != 0:
        send_messages(queue, messages)
        print(".", end="")
        sys.stdout.flush()


def lambda_handler(event, context):
    queue_name = "landing-queue-2152"

    for lambda_event in event['Records']:
        bucket = lambda_event['s3']['bucket']['name']
        key = unquote_plus(lambda_event['s3']['object']['key'], encoding='utf-8')
        pack_file(bucket, key, queue_name)
