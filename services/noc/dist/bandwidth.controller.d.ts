import { BandwidthService } from './bandwidth.service';
import { LoginDto } from './dto/login.dto';
export declare class BandwidthController {
    private readonly bandwidthService;
    constructor(bandwidthService: BandwidthService);
    login(dto: LoginDto): {
        authenticated: boolean;
        user: string;
    };
}
