import logging
from datetime import datetime

import boto3
import json

logger = logging.getLogger(__name__)


def lambda_handler(event, context):
    for lambda_event in event["Records"]:
        payload = json.loads(lambda_event["body"])
        attributes = lambda_event["messageAttributes"]
        print(payload)
        print(attributes)
