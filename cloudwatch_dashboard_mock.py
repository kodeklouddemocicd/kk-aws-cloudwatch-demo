## original needed changes/// be sure to run put script in app.py 
                 ## WHAT DOES THE SCRIPT DO ? ##
   ## IT RUNS A DYNAMODB TABLE THAT KEEPS PUTTING DATA IN TABLE
## BEFORE YOU RUN CHANGE THE REGION ITS GOING TO BE RAN ## READ LINE 25
#______ RUN THESES COMMANDS FOR DEPENDENCIES FIRST_______
# 1. sudo su 
# 2. cd 
# 3. curl -O https://bootstrap.pypa.io/pip/3.7/get-pip.py
# 4. sudo yum install stress -y 
# 5. mkdir application_01 <<<< this is where your application for requirements of pip and source code will be stored 
# 6. cd application_01
# 7. vi requirements.txt >>> insert/save: boto3
# 8. cat requirements >> output: boto3 
# 9. pip3 install -r requirements.txt 
# 10. vi app.py >> insert python code for db make sure the correct region or you will not see it 
# 11. python3 app.py  <<< runs the application check the dynamodb table for creation 
## ______ AFTER THE INSTALL RUN BASH SCRIPT >> FROM OTHER FILE OF REPO >> MAKE SURE TO RUN A SECOND EC2 CONNECT OR IT WILL STOP 

import boto3
import random
import time
import decimal
from botocore.exceptions import ClientError

# Change this to the same region where your EC2 instance is running line 
AWS_REGION = "us-east-1"

dynamodb = boto3.resource("dynamodb", region_name=AWS_REGION)
table_name = "ShoppingData"


def create_table():
    try:
        table = dynamodb.create_table(
            TableName=table_name,
            KeySchema=[
                {
                    "AttributeName": "order_id",
                    "KeyType": "HASH"
                }
            ],
            AttributeDefinitions=[
                {
                    "AttributeName": "order_id",
                    "AttributeType": "S"
                }
            ],
            BillingMode="PAY_PER_REQUEST"
        )

        print(f"Creating table {table_name}...")
        table.wait_until_exists()
        print(f"Table {table_name} created successfully.")

    except ClientError as e:
        if e.response["Error"]["Code"] == "ResourceInUseException":
            print(f"Table {table_name} already exists.")
        else:
            print(f"Unexpected error creating table: {e}")
            raise


def put_random_shopping_data():
    table = dynamodb.Table(table_name)
    counter = 0

    while True:
        order_id = f"order_{random.randint(1, 100000)}"
        item_name = f"item_{random.randint(1, 100)}"
        quantity = random.randint(1, 20)
        price = decimal.Decimal(str(round(random.uniform(1, 1000), 2)))

        try:
            table.put_item(
                Item={
                    "order_id": order_id,
                    "item_name": item_name,
                    "quantity": quantity,
                    "price": price
                }
            )

            print(f"PutItem succeeded: {order_id}, {item_name}, {quantity}, ${price}")
            counter += 1

            if counter % 100 == 0:
                print("Inserted 100 records. Sleeping for 1 minute...")
                time.sleep(60)

            time.sleep(1)

        except ClientError as e:
            print(f"Error inserting item: {e}")
            time.sleep(5)


if __name__ == "__main__":
    create_table()
    put_random_shopping_data()
