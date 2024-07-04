import boto3
import json
import datetime

# Cost monitoring python lambda codes

def lambda_handler(event, context):
    client = boto3.client('ce', region_name='us-east-1') # Replace with your region
    
    # Define the time period for cost calculation
    now = datetime.datetime.utcnow()
    start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    end = now

    time_period = {
        'Start': start.strftime('%Y-%m-%d'),
        'End': end.strftime('%Y-%m-%d')
    }

    response = client.get_cost_and_usage(
        TimePeriod=time_period,
        Granularity='MONTHLY',
        Metrics=['BlendedCost']
    )

    amount = float(response['ResultsByTime'][0]['Total']['BlendedCost']['Amount'])

    threshold = 0.00 # Set your cost threshold here

    if amount > threshold:
        sns_client = boto3.client('sns')
        sns_client.publish(
            TopicArn='arn:aws:sns:us-east-1:059978233428:cost-alerts', # Replace with your SNS topic ARN
            Message=f'Alert: Monthly AWS cost has exceeded ${threshold}. Current cost: ${amount}',
            Subject='AWS Cost Alert'
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Cost monitoring executed successfully!')
    }
