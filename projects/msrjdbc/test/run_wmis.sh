curl --location --request POST 'http://wmis.sttlab.eu:5555/msrjdbcAPI/sources' \
--header 'accept: application/json' \
--header 'Authorization: Basic QWRtaW5pc3RyYXRvcjpyZWc2ckVzcy1zdHJPbGxlci11bnRVcm45ZWQ=' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "value=$1"
