
# create s3 bucket for your state
aws s3api create-bucket --bucket prodxcloud-state-bucket --region us-east-1
# copy state
aws s3 cp . s3://prodxcloud-state-bucket  --recursive
# remove all
aws s3 rm s3://prodxcloud-state-bucket --recursive

aws s3 cp . s3://dev.prodxcloud.io  --recursive
