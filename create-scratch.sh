sfdx force:org:create -f config/project-scratch-def.json -a Scratch -d 14 -s
sfdx force:source:push
sfdx force:user:create -a salesguy -f config/sales-user.json
sfdx force:user:create -a contractmgt -f config/contract-manager.json