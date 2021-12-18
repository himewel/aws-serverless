resource "aws_dynamodb_table" "ingestion_schema_table" {
  hash_key       = "id"
  name           = "ingestion-schema-2152"
  range_key      = "domain"
  read_capacity  = 20
  write_capacity = 20

  local_secondary_index {
      name = "domain"
      range_key = "domain"
      projection_type = "INCLUDE"
      non_key_attributes = [
          "mapping",
          "schema",
          "destination",
          "column_keys",
          "date_keys",
          "partition_columns",
      ]
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "domain"
    type = "S"
  }
}

resource "aws_dynamodb_table" "ingestion_log_table" {
  hash_key       = "id"
  name           = "ingestion-log-2152"
  range_key      = "domain"
  read_capacity  = 20
  write_capacity = 20

  local_secondary_index {
      name = "domain"
      range_key = "domain"
      projection_type = "INCLUDE"
      non_key_attributes = [
          "flag_sucess",
          "error_message",
          "ingested_rows",
          "final_rows",
      ]
  }

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "domain"
    type = "S"
  }
}
