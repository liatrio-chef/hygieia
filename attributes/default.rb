default['hygieia_liatrio']['user']                = 'hygieia'
default['hygieia_liatrio']['group']               = 'hygieia'
default['hygieia_liatrio']['home']                = '/opt/hygieia'
default['hygieia_liatrio']['symlink']             = '/vagrant/Hygieia/UI/dist'
default['hygieia_liatrio']['parent_cookbook']	= ''
# default['hygieia_liatrio']['collectors']	= %w(core api ui github-scm-collector jenkins-build-collector sonar-codequality-collector udeploy-deployment-collector stash-scm-collector)
# default['hygieia_liatrio']['collectors']	= %w(api-2.0.3.jar chat-ops-collector-2.0.3.jar jenkins-cucumber-test-collector-2.0.3.jar udeploy-deployment-collector-2.0.3.jar aws-cloud-collector-2.0.3.jar jira-feature-collector-2.0.3.jar versionone-feature-collector-2.0.3.jar bamboo-build-collector-2.0.3.jar github-scm-collector-2.0.3.jar sonar-codequality-collector-2.0.3.jar xldeploy-deployment-collector-2.0.3.jar bitbucket-scm-collector-2.0.3.jar jenkins-build-collector-2.0.3.jar subversion-collector-2.0.3.jar)
default['hygieia_liatrio']['collectors']	= %w(api-2.0.3.jar jira-feature-collector-2.0.3.jar github-scm-collector-2.0.3.jar sonar-codequality-collector-2.0.3.jar bitbucket-scm-collector-2.0.3.jar jenkins-build-collector-2.0.3.jar)
default['hygieia_liatrio']['dbname']		= 'dashboard'
default['hygieia_liatrio']['dbhost']		= '127.0.0.1'
default['hygieia_liatrio']['dbport']		= '27017'
default['hygieia_liatrio']['dbusername']		= 'db'
default['hygieia_liatrio']['dbpassword']		= 'dbpass'

default['hygieia_liatrio']['jar_core_version']	= 'core-2.0.4-SNAPSHOT.jar'
default['hygieia_liatrio']['jar_artifactory_version']	= 'artifactory-artifact-collector-2.0.4-SNAPSHOT.jar'

default['hygieia_liatrio']['udeploy_url']	= 'http://192.168.100.40:8080'
default['hygieia_liatrio']['udeploy_username']	= 'admin'
default['hygieia_liatrio']['udeploy_password']	= 'password'
default['hygieia_liatrio']['sonar_url']		= 'http://192.168.100.10:9000/'
default['hygieia_liatrio']['stash_url']		= 'http://192.168.100.60:7990/'
