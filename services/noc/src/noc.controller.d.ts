import { NocService } from './noc.service';
export declare class NocController {
    private readonly nocService;
    constructor(nocService: NocService);
    getStatus(): {
        status: string;
        service: string;
    };
}
//# sourceMappingURL=noc.controller.d.ts.map