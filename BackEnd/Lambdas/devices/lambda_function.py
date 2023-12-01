from devices_service import DevicesService
import json

def lambda_handler(event, context):
    # método HTTP
    http_method = event['httpMethod']
    # verificar qual o caso de uso da requisição
    req_option = event['pathParameters']['proxy'].split('/')[0]
    
    # instanciar o users service
    service = DevicesService()
    
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
    
    # Registrar dispositivo
    if http_method == 'POST' and req_option == 'create':
        return service.create_device(event)
    
    # Obter dispositivos
    if http_method == 'GET' and req_option == 'list':
        return service.get_devices(event)
    
    # Atualizar infos dispositivo
    if http_method == 'PUT' and req_option == 'update':
        return service.update_device(event)
    
    # Remover dispositivo
    if http_method == 'DELETE' and req_option == 'remove':
        return service.remove_device(event)
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Retorno final: Devices Lambda')
    }
