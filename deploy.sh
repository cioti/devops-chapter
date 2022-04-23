
SERVICES=$1
APPS_PATH="apps/staging"
pull_request() {
  to_branch=$1
  if [ -z $to_branch ]; then
    to_branch="main"
  fi
  
  # try the upstream branch if possible, otherwise origin will do
  upstream=$(git config --get remote.upstream.url)
  origin=$(git config --get remote.origin.url)
  if [ -z $upstream ]; then
    upstream=$origin
  fi
  
  to_user=$(echo $upstream | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')
  from_user=$(echo $origin | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')
  repo=$(basename `git rev-parse --show-toplevel`)
  from_branch=$(git rev-parse --abbrev-ref HEAD)
  open "https://github.com/$to_user/$repo/pull/new/$to_user:$to_branch...$from_user:$from_branch"
}


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

pull_request
# echo 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 > .githubtoken
# gh auth login --with-token < .githubtoken
# gh pr create --title "The bug is fixed" --body "Everything works again"
}

# split services by ','
for svc in ${SERVICES//,/ } ; do 
    createPullRequest $svc
done 