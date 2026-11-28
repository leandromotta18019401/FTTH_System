"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.BandwidthController = void 0;
const common_1 = require("@nestjs/common");
const bandwidth_service_1 = require("./bandwidth.service");
const login_dto_1 = require("./dto/login.dto");
let BandwidthController = class BandwidthController {
    bandwidthService;
    constructor(bandwidthService) {
        this.bandwidthService = bandwidthService;
    }
    login(dto) {
        return this.bandwidthService.login(dto);
    }
};
exports.BandwidthController = BandwidthController;
__decorate([
    (0, common_1.Post)('login'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [login_dto_1.LoginDto]),
    __metadata("design:returntype", void 0)
], BandwidthController.prototype, "login", null);
exports.BandwidthController = BandwidthController = __decorate([
    (0, common_1.Controller)('bandwidth'),
    __metadata("design:paramtypes", [bandwidth_service_1.BandwidthService])
], BandwidthController);
//# sourceMappingURL=bandwidth.controller.js.map