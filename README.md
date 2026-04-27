A simple railway service which automatically backs up a postgres database service, made to be used on a CRON service.

## Setup

To start setting up your service, first create your bucket by pressing `add` > `bucket` > `deploy`. Then, on the bucket's credentials tab, click the `add to service` button, select this service and then press `add variables`. This will add most of the below environment variables automatically.<br/>

Now, create a new variable within this service called `DATABASE_URL` with the value of `${{Postgres.DATABASE_URL}}` where `postgres` should be replaced with the name of your database service.

| Variable Name         | Value                                                |
| --------------------- | ---------------------------------------------------- |
| DATABASE_URL          | ${{Postgres.DATABASE_URL}}                           |
| AWS_S3_BUCKET_NAME    | ${{AWS_S3_BUCKET_NAME}}                              |
| AWS_ENDPOINT_URL      | ${{AWS_ENDPOINT_URL}} or `https://t3.storageapi.dev` |
| AWS_ACCESS_KEY_ID     | ${{AWS_ACCESS_KEY_ID}}                               |
| AWS_SECRET_ACCESS_KEY | ${{AWS_SECRET_ACCESS_KEY}}                           |
| AWS_DEFAULT_REGION    | ${{AWS_DEFAULT_REGION}} or `auto`                    |

If you wish to change how often your database is backed up, modify the CRON schedule under `settings` > `deploy` of this service.
