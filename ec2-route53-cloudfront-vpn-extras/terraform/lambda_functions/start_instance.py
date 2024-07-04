import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    ec2.start_instances(InstanceIds=['i-08f1bfcc8c0d8d184']) # Replace with your instance ID
    return {
        'statusCode': 200,
        'body': 'Instance started successfully'
    }



# Improved code

# def lambda_handler(event, context):
#   # Get instance ID from event (or environment variable)
#   instance_id = event.get("InstanceId")
#   if not instance_id:
#       instance_id ='i-08f1bfcc8c0d8d184'
  
#   # Error handling for missing instance ID
#   if not instance_id:
#       print("Error: Missing InstanceId")
#       return {
#           'statusCode': 400,
#           'body': 'Please provide InstanceId either in the event or as an environment variable.'
#       }  

#   # Region name (can be retrieved from context or set as environment variable)
#   region_name = os.environ.get("AWS_REGION", "us-east-1")

#   # Create EC2 client
#   ec2 = boto3.client('ec2', region_name=region_name)

#   # Start the instance
#   try:
#       response = ec2.start_instances(InstanceIds=[instance_id])
#       print("Instance started successfully:", response)
#       return {
#           'statusCode': 200,
#           'body': f"Instance '{instance_id}' started successfully."
#       }
#   except Exception as e:
#       print("Error starting instance:", e)
#       return {
#           'statusCode': 500,
#           'body': f"Error starting instance '{instance_id}': {e}"
#       }
