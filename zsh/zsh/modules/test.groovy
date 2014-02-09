for (slave in hudson.model.Hudson.instance.slaves){
  
  println('-----');
  println('Name: ' + slave.name);
  println('label: ' + slave.label);
}
