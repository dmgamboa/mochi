import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response } from 'express';
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
export class PreAuthMiddleware implements NestMiddleware {
  private defaultApp: any;

  constructor() {
    this.defaultApp = firebase.initializeApp({
      credential: firebase.credential.cert(firebase_params),
      // databaseURL: 'https://fireauth-1.firebaseio.com',
    }, 'auth');
  }

  use(req: Request, res: Response, next: Function) {
    const token = req.headers.authorization;
    if (token != null && token != '') {
      this.defaultApp
        .auth()
        .verifyIdToken(token.replace('Bearer ', '')) // remove Bearer from token
        .then(async (decodedToken) => {
          const user = {
            uid: decodedToken.uid,
            email: decodedToken.email,
          };
          req['user'] = user;
          next();
        })
        .catch((error) => {
          console.log(error);
          res.status(401).send('Unauthorized');
        });
    } else {
      next();
    }
  }
}
