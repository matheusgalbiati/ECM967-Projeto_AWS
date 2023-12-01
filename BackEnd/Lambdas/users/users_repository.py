import boto3
import json

class UsersRepository():
    def __init__(self):
        table_name = 'main_table'
        dynamodb = boto3.resource('dynamodb')
        self.table = dynamodb.Table(table_name)
    
    def create_user(self, user):
        response = self.table.put_item(Item=user)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('User created successfully')
        }
    
    def get_user(self, pk, sk):
        response = self.table.get_item(Key={'PK': pk, 'SK': sk})
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS, GET'
            },
            'body': json.dumps(response['Item'])
        }
    

    
    def update_user(self, user_email, attrib, value):
        pk = 'USERS#' + user_email
        sk = '#USER#' + user_email
        
        response = self.table.update_item(
            ExpressionAttributeNames = {
                '#attrib': attrib
            },
            ExpressionAttributeValues = {
                ':value': value
            },
            Key = {
                'PK': pk,
                'SK': sk
            },
            UpdateExpression = 'SET #attrib = :value',
        )