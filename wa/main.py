import time
from kubernetes import client, config, watch

# Загружаем конфигурацию кластера Kubernetes
config.load_incluster_config()
v1 = client.CoreV1Api()

def update_haproxy_config(svc):
    # Логика обновления конфигурации HAProxy
    print(f"Обновляем конфигурацию HAProxy для сервиса {svc.metadata.name}")
    
    # Здесь вы можете добавить код для изменения конфигурации HAProxy,
    # используя, например, библиотеку py-haproxy-config
    pass

def main():
    w = watch.Watch()
    for event in w.stream(v1.list_service_for_all_namespaces, _request_timeout=60):
        if event['type'] == 'ADDED':
            svc = event['object']
            update_haproxy_config(svc)
            
if __name__ == "__main__":
    main()