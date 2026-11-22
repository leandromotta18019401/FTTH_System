import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FinanceController } from './finance.controller';
import { FinanceService } from './finance.service';
import { Invoice } from './entities/invoice.entity';
import { Payment } from './entities/payment.entity';
import { FiscalRule } from './entities/fiscal_rule.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Invoice, Payment, FiscalRule]),
  ],
  controllers: [FinanceController],
  providers: [FinanceService],
})
export class AppModule {}

