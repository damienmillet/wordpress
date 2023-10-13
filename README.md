# wordpress

docker's image nginx-php-alpine

## Usage
  
```bash
  docker run -p 8888:80 -e PORT='8888' --name wordpress damienmillet/wordpress
```

## Access

`http://localhost:8888`

## Environment variables

|Name|Default Value|Description|
|----|-----|-----------|
|PORT|80|Port exposed by the container, needed cause of wordpress stupid logic|
