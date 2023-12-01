from device_contacts_service import DeviceContactsService
import json

def lambda_handler(event, context):
    # método HTTP
    http_method = event['httpMethod']
    # verificar qual o caso de uso da requisição
    req_option = event['pathParameters']['proxy'].split('/')[0]
    
    # instanciar o device contacts service
    service = DeviceContactsService()
    
    # habilitar CORS preflight - OPTIONS
    if http_method == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': '*'
            }
        }
    
    # Cadastrar contato dispositivo
    if http_method == 'POST' and req_option == 'create':
        return service.create_device_contact(event)
    
    # Obter contatos dispositivo
    if http_method == 'GET' and req_option == 'list':
        return service.get_device_contacts(event)
    
    # Remover contato dispositivo
    if http_method == 'DELETE' and req_option == 'remove':
        return service.remove_device_contact(event)
    
    # Atualizar infos contato dispositivo
    if http_method == 'PUT' and req_option == 'update':
        return service.update_device_contact(event)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Retorno final: Device Contacts Lambda')
    }
