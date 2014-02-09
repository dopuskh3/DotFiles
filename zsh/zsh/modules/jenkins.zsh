
local jenkins_cli
local jenkins_cli_url
local jenkins_server_url

jenkins_server="no-jenkins-server-configured"
jenkins_ssh_port="38844"
jenkins_private_key="$HOME/.ssh/id_rsa_jenkins"

function jenkins () {
  ssh -i ${jenkins_private_key} -p ${jenkins_ssh_port} ${jenkins_server} -- $*
}

function jenkins-nodes () {
  cat <<EOF | jenkins groovysh

  for(s in hudson.model.Hudson.instance.slaves) {
    println(s.name + ': ' + s.getLabelString());
  }
  exit
EOF
}

function jenkins-jobs () {
  jenkins groovysh 'hudson.model.Hudson.instance.items.each() { println it.fullDisplayName }' | grep -v '=='
}
