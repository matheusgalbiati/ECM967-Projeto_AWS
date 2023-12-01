import boto3
import json
from boto3.dynamodb.conditions import Key

class DevicesRepository():
    def __init__(self):
        table_name = 'main_table'
        dynamodb = boto3.resource('dynamodb')
        self.table = dynamodb.Table(table_name)
    
    def create_device(self, device):
        response = self.table.put_item(Item=device)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device registered successfully')
        }
    
    def get_devices(self, user_email):
        response = self.table.query(
            IndexName = 'GSI1',
            ExpressionAttributeValues = {
                ":user_email": user_email
            },
            KeyConditionExpression = 'owner_user_email = :user_email'
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
    
    def update_device(self, device_id, attrib, value):
        pk = 'DEVICES#' + str(device_id)
        sk = '#INFOS#'
        
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
    
    def remove_device(self, device_id):
        pk = 'DEVICES#' + str(device_id)
        sk = '#INFOS#'
        
        # TODO: implementar logica para deletar tudo relacionado ao dispositivo e nao somente a partição de SK #INFOS#
        # mas para fazer isso, preciso recuperar todos os registros em todas as partições desse device e dps deletar um por vez
        # pq o delete_item nao aceita o begins_with
        response = self.table.delete_item(Key = {'PK': pk, 'SK': sk})
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device deleted successfully')
        }
        
