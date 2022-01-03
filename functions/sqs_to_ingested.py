import logging

import boto3
import json
from botocore.exceptions import ClientError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def lambda_handler(event, context):
    kinesis_client = boto3.client("kinesis")
    kinesis_name = "ingested-stream-2152"

    for lambda_event in event["Records"]:
        payload = json.loads(lambda_event["body"])
        logger.info(f"Payload: {payload}")

        attributes = lambda_event["messageAttributes"]
        for key, value in attributes.items():
            attributes[key] = value["stringValue"]
        payload["attributes"] = attributes
        partition_key = attributes["bucket"] + attributes["domain"]
        logger.info(f"Attributes: {attributes}")

        try:
            kinesis_client.put_record(
                StreamName=kinesis_name,
                Data=json.dumps(payload),
                PartitionKey=partition_key,
            )
        except ClientError as e:
            logging.error(e)
            exit(1)
