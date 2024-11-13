import base64
import boto3
import json
import random
import os

# Set up the AWS clients
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

def lambda_handler(event, context):
    try:
        # Get the bucket name
        bucket_name = "pgr301-couch-explorers"
        
        # Get prompt from the POST request body
        body = json.loads(event['body']) if event.get('body') else {}
        prompt = body.get('prompt', "Investors, with circus hats, giving money to developers with large smiles")
        
        # Generate random seed and set up model
        model_id = "amazon.titan-image-generator-v1"
        seed = random.randint(0, 2147483647)
        s3_image_path = f"generated_images/titan_{seed}.png"

        # Create the request
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 1024,
                "width": 1024,
                "seed": seed,
            }
        }

        # Generate image
        response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())

        # Extract and decode the Base64 image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)

        # Upload to S3
        s3_client.put_object(
            Bucket=bucket_name, 
            Key=s3_image_path, 
            Body=image_data,
            ContentType='image/png'
        )

        # Return success response
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Image generated successfully',
                'image_path': f's3://{bucket_name}/{s3_image_path}'
            })
        }
    
    except Exception as e:
        # Return error response
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }