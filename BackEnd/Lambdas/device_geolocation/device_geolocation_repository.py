import boto3
import json
from boto3.dynamodb.conditions import Key

class DeviceGeolocationRepository():
    def __init__(self):
        table_name = 'main_table'
        dynamodb = boto3.resource('dynamodb')
        self.table = dynamodb.Table(table_name)
    
    def get_device_geolocation(self, device_id):
        pk = 'DEVICES#' + str(device_id)
        sk = '#GEOLOCATION#'
        
        response = self.table.get_item(Key={'PK': pk, 'SK': sk})
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'OPTIONS, GET'
            },
            'body': json.dumps(response['Item'])}
        
    def update_device_geolocation(self, geolocation):
        response = self.table.put_item(Item=geolocation)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device geolocation updated successfully')
        }
