# Template to customise msc based image
#

FROM softwareag/webmethods-microservicesruntime:10.11.0.2-slim
LABEL MAINTAINER="" \
	DESCRIPTION="MSRJDBC microservice" \
	COMMENT="MSRJDBC microservice" \
	CUSTOM="true" \
	SAG="true" \
	BUILD=build-msc \
	BUILD-TEMPLATE="MSR Slim 10.11" \
	TYPE="Micro Service"
#user root


# define exposed ports

EXPOSE 5555
EXPOSE 9999


# user to be used when running scripts
USER sagadmin


# files to be added to based image (includes configuration and package)


	#License file is now managed in K8S as a secret, mounted as a volume
	#ADD --chown=sagadmin ./config/msr.xml /opt/softwareag/IntegrationServer/config/licenseKey.xml

	ADD --chown=sagadmin ./packages/MSRJDBC /opt/softwareag/IntegrationServer/packages/MSRJDBC
	ADD --chown=sagadmin ./packages/WmART /opt/softwareag/IntegrationServer/packages/WmART
	ADD --chown=sagadmin ./packages/WmJDBCAdapter /opt/softwareag/IntegrationServer/packages/WmJDBCAdapter
	#ADD --chown=sagadmin ./packages/WmMonitor /opt/softwareag/IntegrationServer/packages/WmMonitor
	ADD --chown=sagadmin ./lib/dd-cjdbc.jar /opt/softwareag/common/lib/ext/dd-cjdbc.jar


	ADD --chown=sagadmin ./projects/msrjdbc/config/msrjdbc.properties /opt/softwareag/IntegrationServer/msrjdbc.properties
       	ADD --chown=sagadmin ./projects/msrjdbc/config/wmis_mssql.xml /opt/softwareag/IntegrationServer/config/jdbc/pool/wmis_mssql.xml
	ADD --chown=sagadmin ./projects/msrjdbc/config/ISCoreAudit.xml /opt/softwareag/IntegrationServer/config/jdbc/function/ISCoreAudit.xml
	#ADD --chown=sagadmin ./projects/msrjdbc/config/DocumentHistory.xml /opt/softwareag/IntegrationServer/config/jdbc/function/DocumentHistory.xml

# Scripts to be executed during build (must be included in add files files above and include path!!)
