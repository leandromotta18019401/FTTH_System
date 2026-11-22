import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { FinanceService } from './finance.service';
import { CreateInvoiceDto } from './dto/create-invoice.dto';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Controller('finance')
export class FinanceController {
  constructor(private readonly financeService: FinanceService) {}

  @Post('invoice')
  async createInvoice(@Body() dto: CreateInvoiceDto) {
    return this.financeService.createInvoice(dto);
  }

  @Get('invoice/:id')
  async getInvoice(@Param('id') id: string) {
    return this.financeService.findInvoice(id);
  }

  @Post('payment')
  async createPayment(@Body() dto: CreatePaymentDto) {
    return this.financeService.createPayment(dto);
  }
}

