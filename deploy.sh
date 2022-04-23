
SERVICES=$1
TOKEN2=$2
APPS_PATH="apps/staging"

createPullRequest(){
svc_name=$1
echo "Service processed is $svc_name"
values_path=`echo $APPS_PATH/$svc_name/values.yaml`

if ! [ -f $values_path ]; then  
    exit 1
fi
git config --global user.email "alexandruc@thelotter.com"
git config --global user.name "alexc-tl"
git checkout -b deploy-$svc_name-1.9.9
yq e '.spec.chart.spec.version = "1.9.9"' -i $values_path

git add -A $values_path
git commit -m "test"
git push -u origin deploy-$svc_name-1.9.9

echo "token is ${GH_SVC_ACCOUNT_TOKEN}"
echo "token2 is ${TOKEN2}"
curl --request POST \
    --url https://api.github.com/repos/cioti/devops-chapter/pulls \
    --header 'authorization: Bearer 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' \
    --header 'content-type: application/json' \
    --data '{"title":"test","body":"Please pull these awesome changes in!","head":"cioti:test-ci","base":"main"}'
}

# split services by ','
for svc in ${SERVICES//,/ } ; do 
    createPullRequest $svc
done 