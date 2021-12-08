# AWS Serverless Challenge

As default values, all the buckets in this project has the suffix "2152" to make then unique in the project. Also, a `./env/credentials.env` file with the aws credentials is expected as default. You can change it in the Makefile by changing the docker commands to provide your credentials in the way you want. First, create the backend bucket where terraform will store and update the infrastructure state:

```shell
aws s3 mb s3://tfbackend-2152
```

Then, initiate the terraform backend with:

```shell
make init TF_PATH="path/to/my/tf/files"
```

To apply the changes in the tf files, run the following:

```shell
make apply TF_PATH="path/to/my/tf/files"
```
