#
# Template to customise msc based image
#

FROM softwareag/webmethods-microservicesruntime:10.11.0.0-slim
LABEL MAINTAINER="" \
	DESCRIPTION="DevOps demo" \
	COMMENT="DevOps demo" \
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



	ADD --chown=sagadmin ./resources/<MSRLicenseFileName>.xml /opt/softwareag/IntegrationServer/config/licenseKey.xml


	ADD --chown=sagadmin ./source/wm-packages /opt/softwareag/IntegrationServer/packages/

# Scripts to be executed during build (must be included in add files files above and include path!!)
