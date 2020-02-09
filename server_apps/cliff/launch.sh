#!/bin/bash
# Modified 20200208

cd conf
rm tomcat-users.xml
wget https://raw.githubusercontent.com/ahalterman/CLIFF-up/master/tomcat-users.xml
$CATALINA_HOME/bin/startup.sh

echo "Downloading CLIFF..."
cd; wget https://github.com/c4fcm/CLIFF/releases/download/v${CLIFF_VERSION}/CLIFF-${CLIFF_VERSION}.war
mv CLIFF-${CLIFF_VERSION}.war /usr/local/tomcat/webapps/

echo "Installing Java and JDK"
apt-get install -y git maven

echo "Downloading CLAVIN..."
cd; git clone https://github.com/Berico-Technologies/CLAVIN.git

#echo "Downloading placenames file from Geonames..."
#cd CLAVIN
#wget http://download.geonames.org/export/dump/allCountries.zip
#unzip allCountries.zip
#rm allCountries.zip

#echo "Compiling CLAVIN"
#mvn compile

#echo "Building Lucene index of placenames--this is the slow one"
#MAVEN_OPTS="-Xmx8g" mvn exec:java -Dexec.mainClass="com.bericotech.clavin.index.IndexDirectoryBuilder"

wget https://github.com/berkmancenter/mediacloud-clavin-build-geonames-index/releases/download/2019-09-06/IndexDirectory.tar.gz
tar zxvf IndexDirectory.tar.gz
mkdir /etc/cliff2
echo "\n\n"
echo "THIS IS THE SPOT WHERE THE INDEX DIR GETS COPIED"
echo "\n\n"
#cp -r IndexDirectory /etc/cliff2/IndexDirectory
mv IndexDirectory /etc/cliff2/IndexDirectory

cd; cd .m2
rm settings.xml; wget https://raw.githubusercontent.com/ahalterman/CLIFF-up/master/settings.xml

echo "Move files around and redeploy"
$CATALINA_HOME/bin/shutdown.sh
$CATALINA_HOME/bin/catalina.sh run
