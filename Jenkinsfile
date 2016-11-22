elifeLibrary {
    stage 'Checkout', {
        checkout scm
    }

    stage 'Project tests', {
        elifeLocalTests "./project_tests.sh"
        echo 'Checking changes have not been generated by the style checker. If this fails, run .lint.sh from your the venv/ virtualenv'
        sh 'git diff --exit-code'
    }

    stage 'Corpus generation', {
        sh './download-elife-xml.sh'
        sh './generate-article-json.sh'
        archive 'generation.log'
        sh './generate-statistics.sh generation.log'
    }

    stage 'Corpus validation', {
        sh './validate-all-json.sh'
        archive 'validation.log'
        sh './validate-statistics.sh validation.log'
    }
    
    elifeMainlineOnly {    
        stage 'Master', {
            elifeGitMoveToBranch elifeGitRevision(), 'master'
        }
    }
}
