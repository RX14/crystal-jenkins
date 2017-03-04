import jenkins.model.*
import jenkins.security.s2m.*

def jenkins = Jenkins.getInstance()
jenkins.getExtensionList(AdminWhitelistRule).get(AdminWhitelistRule).masterKillSwitch = false
