import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { UserModule } from './user/user.module';
import { TransactionsModule } from './transactions/transactions.module';
import { SettleModule } from './settle/settle.module';
import { PaymentsModule } from './payments/payments.module';

@Module({
  imports: [
    AuthModule,
    UserModule,
    TransactionsModule,
    PaymentsModule,
    SettleModule,
  ],
})
export class AppModule {}
