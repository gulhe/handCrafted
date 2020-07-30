#!/usr/bin/env bash

createAndPushCurrentCommitAsBranchName(){
        git checkout -b ${1} # on créé une branch pour sauver les modifs perdues
        git push origin ${1} # on sauve la branche des modifs perdues
}
dropCurrentBranchButStayInPlace(){
        git checkout --detach && git branch -D ${1} # on déglingue la branche temporaire

}
pushCurrentCommitAsANewRemoteBranch(){
        local ryanBranchName=${1} #on l'appel Ryan parce qu'il faut la sauver .... comme dans le film
        createAndPushCurrentCommitAsBranchName ${ryanBranchName}
        dropCurrentBranchButStayInPlace ${ryanBranchName}
}
saveLocalUnPushedCommits(){
    local head=$(git rev-parse HEAD)
    local om=$(git rev-parse origin/master)
    if [[ ${head} -ne ${om} ]] ; then
        #là, mon petit pote, tu te démerde pour envoyer une notif, je connais pas tes techno magiques mais j'ai totalement confiance !
        local pushedBranchName=${1}
        pushCurrentCommitAsANewRemoteBranch ${pushedBranchName}
        echo on alerte comme on peut que ${pushedBranchName} est dans la place pour être récupéré par on sait pas trop qui "..."
    fi
}

saveWorkingCopy(){
        git add -A # on ajoute tout ce qui aurait pu être modifié mais pas stagé
        git commit --allow-empty -m "Working Copy" # on commit les modifs de la working copy à part du coup (pour bien pouvoir tout avoir dans les bonnes cases à la fin)
}

saveStagingArea(){
        git commit --allow-empty -m "Staged" # on commit tout ce qui aurait pu être stagé mais oublié
}

saveLocalUnCommittedModifications(){
    if [[ -n $(git status -s) ]] ; then #Vérification que aucune modif n'est faite (avec un git status spartiate dont on check si il est non null)
        saveStagingArea
        saveWorkingCopy
    fi
}

PullMaster_Or_SaveModifsAndPullMaster(){
    saveLocalUnCommittedModifications
    saveLocalUnPushedCommits $(date "+%Y-%m-%d_%H-%M-%S")
    git fetch
    git checkout origin/master
    git branch -D master
    git checkout -b master
}

#**
# Parameter 1 : the ref-spec (branche name) of the saved modification branch
reApplySavedModif(){
    local savedModifBranchName=${1}
    local stage=${savedModifBranchName}~
    local workingCopy=${savedModifBranchName}
    git cherry-pick --no-commit ${stage} ${workingCopy}
    git reset ${stage} -- .
}

PullMaster_Or_SaveModifsAndPullMaster
