sfdx force:org:create -f config/project-scratch-def.json -a Scratch -d 14 -s
sfdx force:source:push
sfdx force:user:create -a salesguy -f config/sales-user.json username=sales.user$(date +%s)@country-details.org
sfdx force:user:create -a contractmgt -f config/contract-manager.json username=contract.manager$(date +%s)@country-details.org
sfdx force:user:create -a sysadmin -f config/system-administrator.json username=system.administrator$(date +%s)@country-details.org
sfdx force:user:permset:assign -n CountryDetails -o salesguy,contractmgt
sfdx force:apex:execute -f ./anonymous/restcountries-init.apex