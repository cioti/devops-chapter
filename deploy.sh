
SERVICES=$1
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

# echo "$GH_SVC_ACCOUNT_TOKEN" > .githubtoken
# unset GH_SVC_ACCOUNT_TOKEN
# gh auth login --with-token < .githubtoken
# rm .githubtoken
gh pr create --title "The bug is fixed" --body "Everything works again"
}

# split services by ','
for svc in ${SERVICES//,/ } ; do 
    createPullRequest $svc
done 