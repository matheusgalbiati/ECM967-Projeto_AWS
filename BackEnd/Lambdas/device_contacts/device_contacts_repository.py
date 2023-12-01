import boto3
import json
from boto3.dynamodb.conditions import Key

class DeviceContactsRepository():
    def __init__(self):
        table_name = 'main_table'
        dynamodb = boto3.resource('dynamodb')
        self.table = dynamodb.Table(table_name)
    
    def create_device_contact(self, device_contact, device_id, contact_email):
        # adicionar contato na entidade do dispositivo
        response = self.table.put_item(Item=device_contact)
        
        # obter o apelido do dispositivo para preencher automaticamente para o contato compartilhado
        pk = 'DEVICES#' + str(device_id)
        sk = '#INFOS#'
        response = self.table.get_item(Key={'PK': pk, 'SK': sk})
        device_infos = response['Item']
        device_nickname = device_infos['device_nickname']
        device_photo_id = device_infos['device_photo_id']
        
        # adicionar esse device no contato compartilhado para acesso deste
        shared_device = {
            "PK": 'USERS#' + contact_email,
            "SK": '#DEVICES#' + device_id,
            "is_primary": 'false',
            "is_secondary": 'false',
            "shared_device_nickname": device_nickname,
            "device_photo_id": device_photo_id
        }
        response = self.table.put_item(Item=shared_device)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device contact registered successfully')
        }
    
    def get_device_contacts(self, device_id):
        pk = 'DEVICES#' + str(device_id)
        
        response = self.table.query(
            KeyConditionExpression = Key('PK').eq(pk) & Key('SK').begins_with('#CONTACTS#')
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
    
    def update_device_contact(self, device_id, contact_email, attrib, value):
        pk = 'DEVICES#' + str(device_id)
        sk = '#CONTACTS#' + contact_email
        
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
    
    def remove_device_contact(self, device_id, contact_email):
        # remover o contato do dispositivo
        pk = 'DEVICES#' + str(device_id)
        sk = '#CONTACTS#' + contact_email
        
        response = self.table.delete_item(Key = {'PK': pk, 'SK': sk})
        
        # remover o dispositivo compartilhado com o contato
        pk = 'USERS#' + contact_email
        sk = '#DEVICES#' + str(device_id)
        
        response = self.table.delete_item(Key = {'PK': pk, 'SK': sk})
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device contact deleted successfully')
        }
        