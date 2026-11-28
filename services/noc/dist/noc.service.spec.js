"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const noc_service_1 = require("./noc.service");
describe('NocService', () => {
    let service;
    beforeEach(() => {
        service = new noc_service_1.NocService();
    });
    it('deve retornar o status online do serviço NOC', () => {
        expect(service.getStatus()).toEqual({
            status: 'online',
            service: 'NOC',
        });
    });
});
//# sourceMappingURL=noc.service.spec.js.map