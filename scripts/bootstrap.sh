#!/usr/bin/env bash
# shell script provisioning for Vagrant box.
#

# varibales
export LOCAL_USER=vagrant

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# common
sudo apt-get install -y git
sudo apt-get install -y rsync

# hadoop dependency
sudo apt-get install -y openjdk-7-jre
sudo apt-get install -y openjdk-7-jdk

# download hadoop package
wget http://apache.stu.edu.tw/hadoop/common/stable/hadoop-2.7.2.tar.gz
tar -xzvf hadoop-2.7.2.tar.gz
chown -R ${LOCAL_USER}.${LOCAL_USER} hadoop-2.7.2/
ln -s hadoop-2.7.2 hadoop

# overwrite core-site.xml
cp /vagrant/scripts/core-site.xml hadoop-2.7.2/etc/hadoop

# modify and reload .bashrc
echo "## appended by vagrant -- begin                                      " >> .bashrc
echo "#JDK Installation Path                                               " >> .bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64                   " >> .bashrc
echo "# Hadoop Path                                                        " >> .bashrc
echo "export HADOOP_HOME=/usr/" ${LOCAL_USER} "/hadoop                     " >> .bashrc
echo "# Set Path                                                           " >> .bashrc
echo "export PATH=$PATH:$HADOOP_HOME/bin                                   " >> .bashrc
echo "export PATH=$PATH:$HADOOP_HOME/sbin                                  " >> .bashrc
echo "# Set Environment Variables of Hadoop                                " >> .bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME                               " >> .bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME                               " >> .bashrc
echo "export HADOOP_HDFS_HOME=$HADOOP_HOME                                 " >> .bashrc
echo "export YARN_HOME=$HADOOP_HOME                                        " >> .bashrc
echo "export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native          " >> .bashrc
echo "export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"            " >> .bashrc
echo "# Set library                                                        " >> .bashrc
echo "export JAVA_LIBRARY_PATH=$HADOOP_HOME/lib/native:$JAVA_LIBRARY_PATH  " >> .bashrc
echo "export PATH=${JAVA_HOME}/bin:${PATH}                                 " >> .bashrc
echo "export HADOOP_TOOLSPATH=$HADOOP_HOME/share/hadoop/tools              " >> .bashrc
echo "export HADOOP_CLASSPATH=${JAVA_HOME}/lib/tools.jar                   " >> .bashrc
echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:$HADOOP_TOOLSPATH/lib/hadoop-aws-2.7.2.jar         " >> .bashrc
echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:$HADOOP_TOOLSPATH/lib/aws-java-sdk-1.7.4.jar       " >> .bashrc
echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:$HADOOP_TOOLSPATH/lib/hadoop-distcp-2.7.2.jar      " >> .bashrc
echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:$HADOOP_TOOLSPATH/lib/jackson-databind-2.2.3.jar   " >> .bashrc
echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:$HADOOP_TOOLSPATH/lib/jackson-core-2.2.3.jar       " >> .bashrc
echo "export HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:$HADOOP_TOOLSPATH/lib/jackson-annotations-2.2.3.jar" >> .bashrc
echo "## appended by vagrant -- end                                        " >> .bashrc
source .bashrc

# clean up
rm hadoop-2.7.2.tar.gz
