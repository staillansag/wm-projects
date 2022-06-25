curl --location --request POST 'http://msr.sttlab.eu:5555/msrjdbcAPI/sources' \
--header 'accept: application/json' \
--header 'Authorization: Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "value=$1$2"
echo

