
SERVICES=$1
APPS_PATH="apps/staging"

createPullRequest(){
svc_name=$1
echo "Service processed is $svc_name"
values_path=`echo $APPS_PATH/$svc_name/values.yaml`

echo "Values path=$values_path"
if [ -f $values_path ]; then  
    echo "values file exists"
fi
git config --global user.email "service@account.net"
git config --global user.name "service_account"
git checkout -b deploy-$svc_name-1.9.9
yq e '.spec.chart.spec.version = "1.9.9"' -i $values_path

git add -A $values_path
git commit -m "test"
git push -u origin deploy-$svc_name-1.9.9
gh pr create --title "The bug is fixed" --body "Everything works again"
}

# split services by ','
for svc in ${SERVICES//,/ } ; do 
    createPullRequest $svc
done 