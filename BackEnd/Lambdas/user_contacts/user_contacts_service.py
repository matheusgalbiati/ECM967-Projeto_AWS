from user_contacts_repository import UserContactsRepository
import json

class UserContactsService():
    def __init__(self):
        self.repository = UserContactsRepository()
    
    def get_shared_devices(self, event):
        user_email = event['pathParameters']['proxy'].split('/')[1]
        
        return self.repository.get_shared_devices(user_email)
        
    def update_shared_device(self, event):
        user_email = event['pathParameters']['proxy'].split('/')[1]
        device_id = event['pathParameters']['proxy'].split('/')[2]
        
        body = json.loads(event['body'])
        
        for attrib, value in body.items():
            self.repository.update_shared_device(user_email, device_id, attrib, value)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('User shared  attributes updated successfully')
        }
    
    def update_home_contact(self, event):
        user_email = event['pathParameters']['proxy'].split('/')[1]
        device_id = event['pathParameters']['proxy'].split('/')[2]
        
        body = json.loads(event['body'])
        preference = body['preference']
        
        # obter todos os devices compartilhados com esse usuário
        devices = self.repository._get_shared_devices(user_email)
        
        # procurar os devices cujo is_primary e is_secondary é true
        primary_device = None
        secondary_device = None
        
        # return {'body': json.dumps(devices[0]['is_primary'])}
        
        for device in devices:
            if device['is_primary'] == 'true':
                primary_device = device['SK'].split('#')[2]
            if device['is_secondary'] == 'true':
                secondary_device = device['SK'].split('#')[2]
        
        # Atualizar o is_primary do device em questão para true e mudar is_primary do antigo para false
        if preference == 1:
            # verificar se existe algum dispositivo já definido como primário
            if primary_device:
                if device_id == secondary_device:
                    # atualizar o dispositivo primário para secundário
                    self.repository.update_shared_device(user_email, primary_device, 'is_primary', 'false')
                    self.repository.update_shared_device(user_email, primary_device, 'is_secondary', 'true')
                    # atualizar dispositivo alvo para true
                    self.repository.update_shared_device(user_email, device_id, 'is_primary', 'true')
                    self.repository.update_shared_device(user_email, device_id, 'is_secondary', 'false')
                else:
                    # atualizar esse dispositivo para false
                    self.repository.update_shared_device(user_email, primary_device, 'is_primary', 'false')
                    # atualizar dispositivo alvo para true
                    self.repository.update_shared_device(user_email, device_id, 'is_primary', 'true')
            else:
                # atualizar dispositivo alvo para true
                self.repository.update_shared_device(user_email, device_id, 'is_primary', 'true')
        
        # Atualizar o is_secondary do device em questão para true e mudar is_secondary do antigo para false
        if preference == 2:
            # verificar se existe algum dispositivo já definido como secundário
            if secondary_device:
                if device_id == primary_device:
                    # atualizar o dispositivo secundário para primário
                    self.repository.update_shared_device(user_email, secondary_device, 'is_secondary', 'false')
                    self.repository.update_shared_device(user_email, secondary_device, 'is_primary', 'true')
                    # atualizar dispositivo alvo para true
                    self.repository.update_shared_device(user_email, device_id, 'is_secondary', 'true')
                    self.repository.update_shared_device(user_email, device_id, 'is_primary', 'false')
                else:
                    # atualizar esse dispositivo para false
                    self.repository.update_shared_device(user_email, secondary_device, 'is_secondary', 'false')
                    # atualizar dispositivo alvo para true
                    self.repository.update_shared_device(user_email, device_id, 'is_secondary', 'true')
            else:
                # atualizar dispositivo alvo para true
                self.repository.update_shared_device(user_email, device_id, 'is_secondary', 'true')
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            },
            'body': json.dumps('Home contact preference updated successfully')
        }
