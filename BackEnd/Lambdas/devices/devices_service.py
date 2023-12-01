from devices_repository import DevicesRepository
import json

class DevicesService():
    def __init__(self):
        self.repository = DevicesRepository()
    
    def create_device(self, event):
        body = json.loads(event['body'])
        
        # preparar os valores de PK e SK
        pk = 'DEVICES#' + str(body['device_id'])
        sk = '#INFOS#'
        
        # definir device para o dynamodb
        device = {
            "PK": pk,
            "SK": sk,
            "owner_user_email": body['user_email'],
            "device_nickname": body['device_nickname'],
            "device_photo_id": str(body['device_photo_id'])
        }
        
        return self.repository.create_device(device)
    
    def get_devices(self, event):
        user_email = event['pathParameters']['proxy'].split('/')[1]
        
        pk = 'USERS#' + user_email
        sk = '#USER#' + user_email
        
        return self.repository.get_devices(user_email)
    
    def update_device(self, event):
        device_id = event['pathParameters']['proxy'].split('/')[1]
        
        body = json.loads(event['body'])
        
        for attrib, value in body.items():
            self.repository.update_device(device_id, attrib, value)
            
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device attributes updated successfully')
        }
    
    def remove_device(self, event):
        device_id = event['pathParameters']['proxy'].split('/')[1]
        
        return self.repository.remove_device(device_id)
