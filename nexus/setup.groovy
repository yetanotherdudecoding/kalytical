import groovy.json.JsonOutput
security.setAnonymousAccess(true)
log.info('Anonymous access enabled')

// create hosted repo and expose via https to allow deployments


def newPrivileges = ['nx-repository-view-docker-*-*']

security.addRole('docker-all','docker-all','All docker privleges',newPrivileges,['nx-admin'])

def newRoles = ['docker-all']
//security.addRole('dockeradmin','dockeradmin','admin for docker activities',newPrivileges,null)
security.addUser('docker','docker','savoy','docker@localhost.com',true,'dockerpass',newRoles)
// create group and allow access via https
//def groupMembers = ['docker']
//repository.createDockerGroup('docker-all', null, 8080, groupMembers, true)
log.info('Created docker-all role and added docker user with password: dockerpass')


repository.createDockerHosted('docker-dev',8080,null,'default',true,true)

log.info('Created docker-dev repository, served at port 8080')


// create a new blob store dedicated to usage with raw repositories
def rawStore = blobStore.createFileBlobStore('raw-artifacts', 'default')

// and create a first raw hosted repository for documentation using the new blob store
repository.createRawHosted('raw-artifacts', rawStore.name)

log.info('Created raw-artifact repository')

// create a new blob store dedicated to usage of data product artifacts 
def dpStore = blobStore.createFileBlobStore('dataproducts', 'default')

// and create a first raw hosted repository for documentation using the new blob store
repository.createRawHosted('dataproducts', dpStore.name)

log.info('Created dataproducts repository')

log.info('Script completed successfully')
