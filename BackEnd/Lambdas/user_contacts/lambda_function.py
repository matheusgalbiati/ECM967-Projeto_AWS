from user_contacts_service import UserContactsService
import json

def lambda_handler(event, context):
    # método HTTP
    http_method = event['httpMethod']
    # verificar qual o caso de uso da requisição
    req_option = event['pathParameters']['proxy'].split('/')[0]
    
    # instanciar o users service
    service = UserContactsService()
    
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
    
    # Obter dispositivos compartilhados para o usuário
    if http_method == 'GET' and req_option == 'list':
        return service.get_shared_devices(event)
    
    # Atualizar dispositivo compartilhado para o usuário
    if http_method == 'PUT' and req_option == 'update':
        return service.update_shared_device(event)
    
    # Remover dispositivo compartilhado para o usuário
    # if http_method == 'DELETE' and req_option == 'remove':
    #     return service.remove_shared_device(event)
    
    # Definir dispositivo como primário ou secundário
    if http_method == 'POST' and req_option == 'home_contact':
        return service.update_home_contact(event)
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Retorno final: User contacts Lambda')
    }
