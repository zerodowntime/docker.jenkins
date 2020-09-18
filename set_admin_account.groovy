#!/usr/bin/env groovy

import hudson.security.*
import jenkins.model.*

def env = System.getenv()
def JENKINS_USER
def JENKINS_PASSWORD

if (env.ADMIN_PASSWORD_FILE){
  println "Reading credentials from file"
  def user_data = new File(env.ADMIN_PASSWORD_FILE).text.split(" ")
  JENKINS_USER = user_data[0].trim()
  JENKINS_PASSWORD = user_data[1].trim()
}
else {
  println "File with credentials has been not found"
  println "Quiting setup admin account script"
  return 0
}

def instance = Jenkins.get()

if(!(instance.getSecurityRealm() instanceof HudsonPrivateSecurityRealm))
    instance.setSecurityRealm(new HudsonPrivateSecurityRealm(false))

if(!(instance.getAuthorizationStrategy() instanceof FullControlOnceLoggedInAuthorizationStrategy))
    instance.setAuthorizationStrategy(new FullControlOnceLoggedInAuthorizationStrategy().setAllowAnonymousRead(false))

def users = instance.getSecurityRealm().getAllUsers().collect { it.toString() }

// Create the admin user account if it doesn't already exist.

if (JENKINS_USER in users) {

    println ""
    println "******"
    println "Admin user already exists - updating password"
    println "******"
    println ""

    def password = hudson.security.HudsonPrivateSecurityRealm.Details.fromPlainPassword(JENKINS_PASSWORD)
    def user = hudson.model.User.get(JENKINS_USER)
    user.addProperty(password)
    user.save()
}
else {

    println "******"
    println "Creating local admin user"
    println "******"

    instance.getSecurityRealm().createAccount(JENKINS_USER, JENKINS_PASSWORD)
}

instance.save()
