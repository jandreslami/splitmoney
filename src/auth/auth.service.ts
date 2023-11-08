import { Injectable } from '@nestjs/common';

@Injectable({})
export class AuthService {
  signUp() {
    return 'User signed up';
  }

  logIn() {
    return 'Successful login';
  }
}
