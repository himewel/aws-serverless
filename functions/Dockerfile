FROM amazon/aws-lambda-python

ENV JAVA_HOME "/usr/lib/jvm/java-11-openjdk-amd64"
ENV SPARK_HOME "/opt/spark"
ENV SPARK_NO_DAEMONIZE TRUE

ENV PATH "${PATH}:${JAVA_HOME}/bin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin"
ENV PATH "${PATH}:/home/spark/.local/bin"

RUN mkdir -p /usr/share/man/man1 \
    && yes | yum update \
    && yes | yum -y install \
        java-11-openjdk-devel \
        wget \
        ssh \
        tar \
        gzip

RUN wget -q https://ftp.unicamp.br/pub/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz \
    && tar -xf spark-3.1.2-bin-hadoop3.2.tgz \
    && rm -rf spark-3.1.2-bin-hadoop3.2.tgz \
    && mv spark-3.1.2-bin-hadoop3.2 ${SPARK_HOME}

COPY requirements.txt .
RUN pip install \
    --requirement requirements.txt \
    --target ${LAMBDA_TASK_ROOT}

COPY landing_to_sqs.py ${LAMBDA_TASK_ROOT}
COPY sqs_to_raw.py ${LAMBDA_TASK_ROOT}

CMD [ "lambda_to_sqs.lambda_handler" ]
