# self-signed-ssl

Создание самоподписанного сертификата

Для создания корневого сертификата запустить create_root_cert_and_key.sh
-o - имя файла (путь)
-d - количество дней

Пример: 
./create_root_cert_and_key.sh -o ~/cert/root -d 365


Для создания сертификата для сайта запустите create_certificate_for_domain.sh

Доработки взяты из stackoverflow.com:

https://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl

