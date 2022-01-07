import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue import DynamicFrame


def sparkSqlQuery(glueContext, query, mapping, transformation_ctx) -> DynamicFrame:
    for alias, frame in mapping.items():
        frame.toDF().createOrReplaceTempView(alias)
    result = spark.sql(query)
    return DynamicFrame.fromDF(result, glueContext, transformation_ctx)


args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# Script generated for node S3 bucket
S3bucket_node1 = glueContext.create_dynamic_frame.from_options(
    format_options={"multiline": False},
    connection_type="s3",
    format="json",
    connection_options={
        "paths": ["s3://ingested-2152/weather_measures"],
        "recurse": True,
    },
    transformation_ctx="S3bucket_node1",
)

# Script generated for node ApplyMapping
ApplyMapping_node2 = ApplyMapping.apply(
    frame=S3bucket_node1,
    mappings=[
        ("Data", "string", "data", "date"),
        ("Hora", "string", "hora", "string"),
        (
            "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)",
            "string",
            "precipitacao",
            "double",
        ),
        (
            "PRESSAO ATMOSFERICA AO NIVEL DA ESTACAO, HORARIA (mB)",
            "string",
            "pressao",
            "double",
        ),
        (
            "`PRESSÃO ATMOSFERICA MAX.NA HORA ANT (AUT) (mB)`",
            "string",
            "pressao_max",
            "double",
        ),
        (
            "`PRESSÃO ATMOSFERICA MIN. NA HORA ANT. (AUT) (mB)`",
            "string",
            "pressao_min",
            "double",
        ),
        ("RADIACAO GLOBAL (Kj/m²)", "string", "radiacao", "double"),
        (
            "TEMPERATURA DO AR - BULBO SECO, HORARIA (°C)",
            "string",
            "temperatura",
            "double",
        ),
        (
            "TEMPERATURA DO PONTO DE ORVALHO (°C)",
            "string",
            "orvalho",
            "double",
        ),
        (
            "`TEMPERATURA MÁXIMA NA HORA ANT. (AUT) (°C)`",
            "string",
            "temperatura_max",
            "double",
        ),
        (
            "`TEMPERATURA MÍNIMA NA HORA ANT. (AUT) (°C)`",
            "string",
            "temperatura_min",
            "double",
        ),
        (
            "`TEMPERATURA ORVALHO MAX. NA HORA ANT. (AUT) (°C)`",
            "string",
            "orvalho_max",
            "double",
        ),
        (
            "`TEMPERATURA ORVALHO MIN. NA HORA ANT. (AUT) (°C)`",
            "string",
            "orvalho_min",
            "double",
        ),
        (
            "`UMIDADE REL. MAX. NA HORA ANT. (AUT) (%)`",
            "string",
            "umidade_max",
            "double",
        ),
        (
            "`UMIDADE REL. MIN. NA HORA ANT. (AUT) (%)`",
            "string",
            "umidade_min",
            "double",
        ),
        (
            "UMIDADE RELATIVA DO AR, HORARIA (%)",
            "string",
            "umidade",
            "double",
        ),
        (
            "VENTO, DIREÇÃO HORARIA (gr) (° (gr))",
            "string",
            "vento_direcao",
            "double",
        ),
        (
            "VENTO, RAJADA MAXIMA (m/s)",
            "string",
            "vento_velocidade_rajada",
            "double",
        ),
        (
            "VENTO, VELOCIDADE HORARIA (m/s)",
            "string",
            "vento_velocidade_horaria",
            "double",
        ),
        ("region", "string", "region", "string"),
        ("state", "string", "state", "string"),
        ("station", "string", "station", "string"),
        ("station_code", "string", "station_code", "string"),
        ("latitude", "string", "latitude", "tinyint"),
        ("longitude", "string", "longitude", "double"),
        ("height", "string", "height", "double"),
        ("attributes.bucket", "string", "attributes.bucket", "string"),
        ("attributes.date", "string", "attributes.date", "timestamp"),
        ("attributes.path", "string", "attributes.path", "string"),
        ("attributes.line", "string", "attributes.line", "string"),
        ("attributes.domain", "string", "attributes.domain", "string"),
    ],
    transformation_ctx="ApplyMapping_node2",
)

# Script generated for node SQL
SqlQuery0 = """
SELECT 
    *,
    DATE_FORMAT(data, "yyyy") AS year_partition,
    DATE_FORMAT(data, "MM") AS month_partition,
    DATE_FORMAT(data, "dd")AS day_partition,
    CAST(CURRENT_TIMESTAMP() AS DATE) AS data_ingestao
FROM myDataSource

"""
SQL_node1641434223602 = sparkSqlQuery(
    glueContext,
    query=SqlQuery0,
    mapping={"myDataSource": ApplyMapping_node2},
    transformation_ctx="SQL_node1641434223602",
)

# Script generated for node S3 bucket
S3bucket_node3 = glueContext.write_dynamic_frame.from_options(
    frame=SQL_node1641434223602,
    connection_type="s3",
    format="glueparquet",
    connection_options={
        "path": "s3://app-2152/weather_measures/",
        "partitionKeys": ["year_partition", "month_partition", "day_partition"],
    },
    format_options={"compression": "snappy"},
    transformation_ctx="S3bucket_node3",
)

job.commit()
