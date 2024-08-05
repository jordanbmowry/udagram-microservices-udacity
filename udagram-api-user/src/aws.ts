import AWS = require('aws-sdk');
import { config } from './config/config';

// Configure AWS
AWS.config.credentials = new AWS.SharedIniFileCredentials({
  profile: config.aws_profile,
});
AWS.config.update({ region: config.aws_region });

export const s3 = new AWS.S3({
  signatureVersion: 'v4',
  params: { Bucket: config.aws_media_bucket },
});

// Generates a public URL for retrieving objects
export function getPublicUrl(key: string): string {
  return `https://${config.aws_media_bucket}.s3.${config.aws_region}.amazonaws.com/${key}`;
}

// Generates an AWS signed URL for uploading objects
export function getPutSignedUrl(key: string): string {
  const signedUrlExpireSeconds = 60 * 5;

  return s3.getSignedUrl('putObject', {
    Bucket: config.aws_media_bucket,
    Key: key,
    Expires: signedUrlExpireSeconds,
    ACL: 'public-read',
  });
}
