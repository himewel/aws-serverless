FROM amazon/aws-lambda-python

COPY requirements.txt .
RUN pip install \
    --requirement requirements.txt \
    --target ${LAMBDA_TASK_ROOT}

COPY landing_to_sqs.py ${LAMBDA_TASK_ROOT}
COPY sqs_to_ingested.py ${LAMBDA_TASK_ROOT}

CMD [ "lambda_to_sqs.lambda_handler" ]
