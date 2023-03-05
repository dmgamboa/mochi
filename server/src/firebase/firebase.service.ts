import { Injectable } from '@nestjs/common';
import * as firebase from 'firebase-admin';
require('dotenv').config();

const firebase_params = {
  type: 'service_account',
  projectId: 'mochi-c4c75',
  privateKeyId: process.env.GOOGLE_PRIVATE_KEY_ID,
  privateKey: process.env.GOOGLE_PRIVATE_KEY.replace(/\\n/g, '\n'),
  clientEmail: process.env.GOOGLE_CLIENT_EMAIL,
  clientId: process.env.GOOGLE_CLIENT_ID,
  authUri: 'https://accounts.google.com/o/oauth2/auth',
  tokenUri: 'https://oauth2.googleapis.com/token',
  authProviderX509CertUrl: 'https://www.googleapis.com/oauth2/v1/certs',
  clientC509CertUrl: process.env.GOOGLE_CLIENT_X509_CERT_URL,
};

@Injectable()
export class FirebaseService {
  constructor() {
    firebase.initializeApp({
      credential: firebase.credential.cert(firebase_params),
      storageBucket: 'gs://mochi-c4c75.appspot.com'
    });
  }
}