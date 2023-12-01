from device_contacts_repository import DeviceContactsRepository
import json

class DeviceContactsService():
    def __init__(self):
        self.repository = DeviceContactsRepository()
    
    def create_device_contact(self, event):
        body = json.loads(event['body'])
        
        # set variáveis que serão usadas em mais de um processo
        device_id = str(body['device_id'])
        contact_email = body['contact_email']
        
        # preparar os valores de PK e SK
        pk = 'DEVICES#' + device_id
        sk = '#CONTACTS#' + contact_email
        
        # definir device_contact para o dynamodb
        device_contact = {
            "PK": pk,
            "SK": sk,
            "device_contact_nickname": body['device_contact_nickname'],
            "contact_photo_id": str(body['contact_photo_id']),
            "approval_status": "waiting"
        }
        
        return self.repository.create_device_contact(device_contact, device_id, contact_email)
    
    def get_device_contacts(self, event):
        device_id = event['pathParameters']['proxy'].split('/')[1]
        
        return self.repository.get_device_contacts(device_id)
    
    def update_device_contact(self, event):
        device_id = event['pathParameters']['proxy'].split('/')[1]
        contact_email = event['pathParameters']['proxy'].split('/')[2]
        
        # TODO: validar se o contato existe no dispositivo e se existir continuar o update, senão retornar erro 4XX: usuário não existe no dispositivo
        
        body = json.loads(event['body'])
        
        for attrib, value in body.items():
            self.repository.update_device_contact(device_id, contact_email, attrib, value)
            
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Device contact attributes updated successfully')
        }
    
    def remove_device_contact(self, event):
        device_id = event['pathParameters']['proxy'].split('/')[1]
        contact_email = event['pathParameters']['proxy'].split('/')[2]
        
        return self.repository.remove_device_contact(device_id, contact_email)
