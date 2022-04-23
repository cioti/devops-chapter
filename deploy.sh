
SERVICES=$1
APPS_PATH="apps/staging"

createPullRequest(){
#service should be in the form name:version -> split by :
$svcArr=${1//:/ }
svc_name=svcArr[0]
svc_version=svcArr[1]

echo "Service processed is $svc_name with version $svc_version"
values_path=`echo $APPS_PATH/$svc_name/values.yaml`
version="1.9.9"
branch_name=`echo release-$svc_name-$svc_version-to-staging`
if ! [ -f $values_path ]; then  
    exit 1
fi
git config --global user.email "service@account.net"
git config --global user.name "service_account"
git checkout -b $branch_name
yq e ".spec.chart.spec.version = \"$svc_version\"" -i $values_path

git add -A $values_path
git commit -m "Version bump $svc_name $svc_version"
git push -u origin $branch_name

curl --request POST \
    --url https://api.github.com/repos/cioti/devops-chapter/pulls \
    --header "authorization: Bearer $GH_SVC_ACCOUNT_TOKEN" \
    --header 'content-type: application/json' \
    --data "{\"title\":\"Release $svc_name v$svc_version to staging\",\"body\":\"Please review these changes in order for flux to sync the changes in staging!\",\"head\":\"cioti:$branch_name\",\"base\":\"main\"}"
}

# split services by ','
for svc in ${SERVICES//,/ } ; do 
    createPullRequest $svc
done 