import { ForbiddenException, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { AuthDto } from './dto';
import * as argon2 from 'argon2';
import { PrismaService } from '../prisma/prisma.service';
import { Prisma } from '@prisma/client';

@Injectable({})
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
  ) {}

  async signUp(dto: AuthDto) {
    const hash = await argon2.hash(dto.password);
    try {
      const user = await this.prisma.user.create({
        data: {
          email: dto.email,
          hash,
        },
      });
      delete user.hash;
      return user;
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ForbiddenException('User already taken');
        }
      }
      throw error;
    }
  }

  async logIn(dto: AuthDto) {
    //  retrieve user by email
    const user = await this.prisma.user.findUnique({
      where: {
        email: dto.email,
      },
    });

    console.log('user:', user);

    // if user not exists throw exception

    if (!user) {
      throw new ForbiddenException('Credentials invalid');
    }

    // compare hashes

    const passwordMatches = await argon2.verify(user.hash, dto.password);

    // if hashes not match throw exception
    if (!passwordMatches) {
      throw new ForbiddenException('Credentials invalid');
    }
    //send back jwt

    const payload = {
      sub: user.id,
      user: user.email,
    };

    return {
      access_token: await this.jwt.signAsync(payload),
    };
  }
}
