import { FinanceService } from './finance.service';
import { CreateInvoiceDto } from './dto/create-invoice.dto';
import { CreatePaymentDto } from './dto/create-payment.dto';
export declare class FinanceController {
    private readonly financeService;
    constructor(financeService: FinanceService);
    createInvoice(dto: CreateInvoiceDto): Promise<any>;
    getInvoice(id: string): Promise<any>;
    createPayment(dto: CreatePaymentDto): Promise<any>;
}
//# sourceMappingURL=finance.controller.d.ts.map