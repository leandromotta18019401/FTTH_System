import { LoginDto } from './dto/login.dto';
export declare class BandwidthService {
    login(dto: LoginDto): {
        authenticated: boolean;
        user: string;
    };
    getBandwidth(): {
        downloadMbps: number;
        uploadMbps: number;
    };
}
