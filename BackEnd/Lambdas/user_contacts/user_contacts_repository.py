import boto3
import json
from boto3.dynamodb.conditions import Key

class UserContactsRepository():
    def __init__(self):
        table_name = 'main_table'
        dynamodb = boto3.resource('dynamodb')
        self.table = dynamodb.Table(table_name)
    
    def get_shared_devices(self, user_email):
        pk = 'USERS#' + user_email
        
        response = self.table.query(
            KeyConditionExpression = Key('PK').eq(pk) & Key('SK').begins_with('#DEVICES#')    
        )
        
        items = response['Items']
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS, GET'
            },
            'body': json.dumps(items)}
        
    def _get_shared_devices(self, user_email):
        pk = 'USERS#' + user_email
        
        response = self.table.query(
            KeyConditionExpression = Key('PK').eq(pk) & Key('SK').begins_with('#DEVICES#')    
        )
        
        items = response['Items']
        
        return items
        
    def update_shared_device(self, user_email, device_id, attrib, value):
        pk = 'USERS#' + user_email
        sk = '#DEVICES#' + str(device_id)
        
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
