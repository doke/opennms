# New ports collection makefile for:	opennms
# Date created:		21 January 2009
# Whom:			Sevan Janiyan <venture37@geeklan.co.uk>
#
# $FreeBSD$
#

PORTNAME=	opennms
PORTVERSION=	1.6.9
CATEGORIES=	net-mgmt java
MASTER_SITES=	SF/opennms/OpenNMS%20Source/stable-${PORTVERSION}
DISTNAME=	${PORTNAME}-source-${PORTVERSION}-1

MAINTAINER=	venture37@geeklan.co.uk
COMMENT=	Enterprise grade network monitoring suite

BUILD_DEPENDS=	rrdtool:${PORTSDIR}/databases/rrdtool12 \
		${JAVAJARDIR}/jicmp.jar:${PORTSDIR}/net/jicmp
RUN_DEPENDS=	rrdtool:${PORTSDIR}/databases/rrdtool12 \
		${JAVAJARDIR}/jicmp.jar:${PORTSDIR}/net/jicmp \
		${JAVAJARDIR}/jrrd.jar:${PORTSDIR}/databases/jrrd

USE_PGSQL=	yes
USE_JAVA=	yes
JAVA_BUILD=	yes
JAVA_RUN=	yes

WRKSRC=		${WRKDIR}/opennms-${PORTVERSION}-1/source
USE_RC_SUBR=	opennms
SUB_FILES=	pkg-message

.include <bsd.port.pre.mk>

.if ${OSVERSION} > 701000
JAVA_VERSION=	1.6+
JAVA_VENDOR=	openjdk
.else
JAVA_VERSION=	1.5+
.endif

post-patch:
	${FIND} ${WRKSRC} -name "*.orig" | ${XARGS} ${RM}

do-build:
	cd ${WRKSRC} && ${SETENV} JAVA_HOME=${JAVA_HOME} WRKSRC=${WRKSRC} MAVEN_OPTS="-Xmx1024m -XX:PermSize=384m" \
	./build.sh -e -Dorg.apache.maven.global-settings=${WRKSRC}/maven/conf/settings.xml -Dopennms.home=${PREFIX}/${PORTNAME} install assembly:attached 

do-install:
	${MKDIR} ${PREFIX}/${PORTNAME}
	cd ${WRKSRC}/target && ${TAR} -zxvf ${PORTNAME}-${PORTVERSION}.tar.gz -C ${PREFIX}/${PORTNAME}
	@ ${CHMOD} +x ${PREFIX}/${PORTNAME}/bin/*
	@ ${CHMOD} +x ${PREFIX}/${PORTNAME}/contrib/*
	@ ${CHMOD} -x ${PREFIX}/${PORTNAME}/contrib/*.README
	@ ${CHMOD} -x ${PREFIX}/${PORTNAME}/contrib/opennms.mib
	@ ${CAT} ${PKGMESSAGE}

.include <bsd.port.post.mk>
